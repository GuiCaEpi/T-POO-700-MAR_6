defmodule Todolist.Repo.Migrations.CreateTeamusers do
  use Ecto.Migration

  def change do
    create table(:teamusers) do
      add :user_id, references(:users, on_delete: :nothing)
      add :team_id, references(:teams, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:teamusers, [:user_id])
    create index(:teamusers, [:team_id])
  end
end
