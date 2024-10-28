defmodule Todolist.Repo.Migrations.AddPrivilegeToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :privilege_level, :integer, default: 0, null: false
    end
    create unique_index(:users, [:email])

    execute """
    ALTER TABLE users
    ADD CONSTRAINT privilege_level_check
    CHECK (privilege_level IN (0, 1, 2))
    """
  end



end
