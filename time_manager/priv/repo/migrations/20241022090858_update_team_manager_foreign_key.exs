defmodule Todolist.Repo.Migrations.UpdateTeamManagerForeignKey do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      remove :manager_id
    end

    # Add the new foreign key column that points to users
    alter table(:teams) do
      add :manager_id, references(:users, on_delete: :delete_all)
    end
  end
end
