defmodule Todolist.Repo.Migrations.UpdateTeamManagerForeignKeyCorrectionRequestsTable do
  use Ecto.Migration

  def change do
    alter table(:correction_requests) do
      remove :manager_id
    end

    # Add the new foreign key column that points to users
    alter table(:correction_requests) do
      add :manager_id, references(:users, on_delete: :delete_all)
    end
  end
end
