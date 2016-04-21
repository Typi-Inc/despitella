defmodule Despite.User do
  use Despite.Web, :model

  schema "users" do
    field :phone_number, :string
    field :gender, :string
    field :username, :string

    timestamps
  end

  @required_fields ~w(phone_number)
  @optional_fields ~w(username gender)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:username, min: 6, max: 100)
    |> unique_constraint(:phone_number)
  end
end
