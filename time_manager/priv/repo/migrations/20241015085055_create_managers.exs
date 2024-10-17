defmodule Todolist.Repo.Migrations.CreateManagers do
  use Ecto.Migration

  def change do
    create table(:managers) do
      add :name, :string
      add :email, :string
      add :password_hash, :string
      add :admin_id, references(:admins, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:managers, [:email])
    create index(:managers, [:admin_id])
  end
end
