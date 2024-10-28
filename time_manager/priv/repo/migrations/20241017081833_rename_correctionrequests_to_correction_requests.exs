defmodule Todolist.Repo.Migrations.RenameCorrectionrequestsToCorrectionRequests do
  use Ecto.Migration

  def up do
    rename table(:correctionrequests), to: table(:correction_requests)
  end

  def down do
    rename table(:correction_requests), to: table(:correctionrequests)
  end
end
