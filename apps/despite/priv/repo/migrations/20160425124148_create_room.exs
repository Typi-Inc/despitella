defmodule Despite.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :title, :string
      add :lat, :string
      add :long, :string
      add :radius, :string
      add :admin_id, references(:users, on_delete: :nothing)

      timestamps
    end

  end
end
