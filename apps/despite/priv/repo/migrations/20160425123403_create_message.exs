defmodule Despite.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :string
      add :sender_id, references(:users, on_delete: :nothing)

      timestamps
    end
    
    create index(:messages, [:sender_id])
  end
end
