defmodule Todolist.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :message, :text
      add :is_read, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)
      add :manager_id, references(:managers, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:notifications, [:user_id])
    create index(:notifications, [:manager_id])
  end
end
