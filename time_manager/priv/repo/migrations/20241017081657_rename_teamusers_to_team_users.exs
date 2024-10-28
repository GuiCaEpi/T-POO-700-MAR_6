defmodule Todolist.Repo.Migrations.RenameTeamusersToTeamUsers do
  use Ecto.Migration

  def up do
    rename table(:teamusers), to: table(:team_users)
  end

  def down do
    rename table(:team_users), to: table(:teamusers)
  end
end
