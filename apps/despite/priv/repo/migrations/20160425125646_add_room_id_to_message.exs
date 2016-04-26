defmodule Despite.Repo.Migrations.AddRoomIdToMessage do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :room_id, references(:rooms)
    end

    create index(:messages, [:room_id])
  end
end
