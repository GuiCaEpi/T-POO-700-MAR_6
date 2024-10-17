defmodule Todolist.Repo.Migrations.CreateCorrectionrequests do
  use Ecto.Migration

  def change do
    create table(:correctionrequests) do
      add :request_message, :text
      add :status, :string, default: "pending"
      add :user_id, references(:users, on_delete: :nothing)
      add :clock_id, references(:clocks, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:correctionrequests, [:user_id])
    create index(:correctionrequests, [:clock_id])
  end
end
