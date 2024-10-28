defmodule Todolist.Repo.Migrations.AddTeamIdToWorkingtimesTable do
  use Ecto.Migration

  def change do
    alter table(:workingtimes) do
      add :team_id, references(:teams, on_delete: :nothing)
    end
  end
end
