defmodule Despite.Repo.Migrations.CreateVerification do
  use Ecto.Migration

  def change do
    create table(:verifications) do
      add :phone_number, :string, null: false
      add :code_hash, :string

      timestamps
    end

    create unique_index(:verifications, [:phone_number])
  end
end
