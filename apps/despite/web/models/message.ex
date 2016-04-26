defmodule Despite.Message do
  use Despite.Web, :model

  schema "messages" do
    field :body, :string
    belongs_to :sender, Despite.User
    belongs_to :room, Despite.Room

    timestamps
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:body, :sender_id, :room_id])
    |> validate_required([:body, :sender_id, :room_id])
  end
end
