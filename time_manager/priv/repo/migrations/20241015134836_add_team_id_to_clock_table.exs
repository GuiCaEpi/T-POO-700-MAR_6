defmodule Todolist.Repo.Migrations.AddTeamIdToClockTable do
  use Ecto.Migration

  def change do
    alter table(:clocks) do
      add :team_id, references(:teams, on_delete: :nothing)
    end
  end
end
