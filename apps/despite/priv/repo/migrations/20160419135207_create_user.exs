defmodule Despite.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :phone_number, :string
      add :gender, :string
      add :username, :string

      timestamps
    end

  end
end
