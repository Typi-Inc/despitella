defmodule Despite.Room do
  use Despite.Web, :model

  schema "rooms" do
    field :title, :string
    field :lat, :string
    field :long, :string
    field :radius, :string
    belongs_to :admin, Despite.User
    has_many :messages, Despite.Message

    timestamps
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:title, :lat, :long, :radius, :admin_id])
    |> validate_required([:title, :admin_id])
  end
end
