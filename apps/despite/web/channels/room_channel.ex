defmodule Despite.RoomChannel do
  use Despite.Web, :channel
  alias Despite.Room

  def join("rooms:" <> room_id, _payload, socket) do
    # TODO if room is private we need to check if the person has been invited
    # but for now all rooms are pulic
    room_id = String.to_integer(room_id)
    room = get_current_room(room_id)
    messages = get_rooms_messages(room)

    resp = %{
      messages: Phoenix.View.render_many(messages, Despite.MessageView, "message.json")
    }
    {:ok, resp, assign(socket, :room_id, room_id)}
  end

  def get_current_room(room_id) do
    # TODO need last 10
    # TODO need to generate messages
    Repo.get(from(Room, preload: [:messages]), room_id)
  end

  def get_rooms_messages(room) do
    Repo.all(
      from message in assoc(room, :messages),
      # where: a.id > ^last_seen_id,
      order_by: [desc: message.inserted_at],
      limit: 10,
      preload: [:sender]
    )
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (rooms:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
