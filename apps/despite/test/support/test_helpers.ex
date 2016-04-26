defmodule Despite.TestHelpers do
  alias Despite.Repo

  def insert_user(attrs \\ %{}) do
    changes = Map.merge(%{
      phone_number: "+112312312",
      username: "user#{Base.encode16(:crypto.rand_bytes(8))}",
    }, attrs)

    %Despite.User{}
    |> Despite.User.changeset(changes)
    |> Repo.insert!
  end

  def insert_room(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:rooms, attrs)
    |> Repo.insert!
  end
end
