defmodule Despite.Verification do
  use Despite.Web, :model

  schema "verifications" do
    field :phone_number, :string
    field :code, :string, virtual: true
    field :code_hash, :string

    timestamps
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, [:phone_number, :code])
    |> validate_required([:phone_number, :code])
    |> validate_format(:phone_number, ~r/^[0-9\+][0-9]{9,15}$/)
    |> put_pass_hash
    |> unique_constraint(:phone_number)
  end

  def put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{code: code}} ->
        put_change(changeset, :code_hash, Comeonin.Bcrypt.hashpwsalt(code))
      _ ->
        changeset
    end
  end
end
