defmodule Despite.UsersChannelTest do
  use Despite.ChannelCase
  import Despite.TestHelpers
  alias Despite.UsersChannel

  setup do
    user = insert_user
    {:ok, token, _full_claims} = Guardian.encode_and_sign(user, :token)
    {:ok, socket} = connect(Despite.UserSocket, %{"token" => token})
    {:ok, socket: socket, user: user}
  end
end
