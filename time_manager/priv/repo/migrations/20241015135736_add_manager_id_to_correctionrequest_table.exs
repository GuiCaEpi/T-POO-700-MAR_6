defmodule Todolist.Repo.Migrations.AddManagerIdToCorrectionrequestTable do
  use Ecto.Migration

  def change do
    alter table(:correctionrequests) do
      add :manager_id, references(:managers, on_delete: :nothing)
    end
  end
end
