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

  def broadcast_message(socket, message) do
    message = Repo.preload(message, :sender)
    rendered_message = Phoenix.View.render(Despite.MessageView, "message.json", %{
      message: message
      })
      broadcast! socket, "new_message", rendered_message
    end

  def handle_in("new_message", payload, socket) do
    changeset = socket.assigns.current_user
    |> build_assoc(:messages, room_id: socket.assigns.room_id)
    |> Despite.Message.changeset(payload)

    case Repo.insert(changeset) do
      {:ok, message} ->
        broadcast_message(socket, message)
        {:reply, :ok, socket}
        {:error, changeset} ->
          {:reply, {:error, %{errors: changeset}}, socket}
        end
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
      order_by: [desc: message.inserted_at, desc: message.id],
      limit: 10,
      preload: [:sender]
    )
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
