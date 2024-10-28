defmodule Todolist.Repo.Migrations.UpdateClocksForeignKey do
  use Ecto.Migration

  def change do
    alter table(:clocks) do
      remove :team_id
      add :team_id, references(:teams, on_delete: :delete_all), null: false
    end
  end
end
