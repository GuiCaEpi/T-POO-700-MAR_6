defmodule Todolist.Repo.Migrations.UpdateWorkingTimesForeignKey do
  use Ecto.Migration

  def change do
    alter table(:workingtimes) do
      remove :team_id
      add :team_id, references(:teams, on_delete: :delete_all), null: false
    end
  end
end
