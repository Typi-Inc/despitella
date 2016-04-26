defmodule Despite.RoomChannelTest do
  use Despite.ChannelCase
  import Despite.TestHelpers
  alias Despite.RoomChannel

  setup do
    user = insert_user
    room = insert_room(user, title: "Testing")
    {:ok, token, _full_claims} = Guardian.encode_and_sign(user, :token)
    {:ok, socket} = connect(Despite.UserSocket, %{"token" => token})
    {:ok, socket: socket, user: user, room: room}
  end

  test "join replies with messages in descending order", %{socket: socket, room: room, user: user} do
    for body <- ~w(one two)  do
      message = %Despite.Message{
        body: body,
        sender: user,
        room: room
      }
      Repo.insert!(message)
    end

    {:ok, reply, socket} = subscribe_and_join(socket, "rooms:#{room.id}", %{})
    assert socket.assigns.room_id == room.id
    assert %{messages: [%{body: "two"}, %{body: "one"}]} = reply
  end

  test "inserting new message", %{socket: socket, room: room, user: user} do
    {:ok, _, socket} = subscribe_and_join(socket, "rooms:#{room.id}", %{})
    ref = push socket, "new_message", %{body: "the body"}
    assert_reply ref, :ok, %{}
    assert_broadcast "new_message", %{body: "the body"}
  end
end
