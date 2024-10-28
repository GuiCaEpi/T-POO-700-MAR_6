defmodule Todolist.Repo.Migrations.DropNotificationsTable do
  use Ecto.Migration
  def up do
    drop table(:notifications)
  end

  def down do
    create table(:notifications) do
      add :message, :string
      add :is_read, :boolean, default: false
      add :user_id, references(:users, on_delete: :nothing, type: :id)
      add :manager_id, references(:managers, on_delete: :nothing, type: :id)

      timestamps(type: :utc_datetime)
    end
  end
end
