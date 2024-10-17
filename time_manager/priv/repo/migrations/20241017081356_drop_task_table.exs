defmodule Todolist.Repo.Migrations.DropTaskTable do
  use Ecto.Migration

  def up do
    drop table(:tasks)
  end

  def down do
    create table(:tasks) do
      add :title, :string
      add :description, :string
      add :status, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
  end
end
