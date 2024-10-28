defmodule Todolist.Repo.Migrations.UpdateTeamUsersForeignKey do
  use Ecto.Migration

  def change do
    alter table(:team_users) do
      remove :team_id
      add :team_id, references(:teams, on_delete: :delete_all), null: false
    end
  end
end
