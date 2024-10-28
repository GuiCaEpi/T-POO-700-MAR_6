defmodule Todolist.Repo.Migrations.RemoveAdminIdFromManagerTable do
  use Ecto.Migration
  def change do
    alter table(:managers) do
      remove :admin_id
    end
  end
end
