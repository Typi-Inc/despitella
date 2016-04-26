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

  test "join replies with messages", %{socket: socket, room: room, user: user} do
    for body <- ~w(one two)  do
      message = %Despite.Message{
        body: body,
        sender: user,
        room: room
      }
      Repo.insert!(message)
    end

    {:ok, reply, socket} = subscribe_and_join(socket, "rooms:#{room.id}", %{})
    IO.puts "#{inspect reply}"
    assert socket.assigns.room_id == room.id
    assert %{messages: [%{body: "one"}, %{body: "two"}]} = reply
  end
end
