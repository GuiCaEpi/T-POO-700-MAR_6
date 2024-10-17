defmodule MyApp.Repo.Migrations.AddStatusToUsers do
  use Ecto.Migration

  def change do
    alter table(:clocks) do
      add :status, :boolean, default: false
    end
  end
end
