defmodule Todolist.Repo.Migrations.ChangeAddPrivilegeLevelFunctionAndTrigger do
  use Ecto.Migration

  def up do
    # Drop the existing trigger and function
    execute """
    DROP TRIGGER IF EXISTS add_to_admin_or_manager ON Users;
    """

    execute """
    DROP FUNCTION IF EXISTS handle_privilege_level();
    """

    # Create the updated function handle_privilege_level()
    execute """
    CREATE OR REPLACE FUNCTION handle_privilege_level()
    RETURNS TRIGGER AS $$
    BEGIN
        IF NEW.privilege_level = 2 THEN
            INSERT INTO Admins (name, email, password_hash, inserted_at, updated_at)
            VALUES (NEW.username, NEW.email, NEW.password, NEW.inserted_at, NEW.updated_at)
            ON CONFLICT (id) DO NOTHING;

            DELETE FROM Managers WHERE id = NEW.id;

        ELSIF NEW.privilege_level = 1 THEN
            INSERT INTO Managers (name, email, password_hash, inserted_at, updated_at)
            VALUES (NEW.username, NEW.email, NEW.password, NEW.inserted_at, NEW.updated_at)
            ON CONFLICT (id) DO NOTHING;

            DELETE FROM Admins WHERE id = NEW.id;
        END IF;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
    """

    # Recreate the trigger add_to_admin_or_manager
    execute """
    CREATE TRIGGER add_to_admin_or_manager
    AFTER INSERT OR UPDATE OF privilege_level
    ON Users
    FOR EACH ROW
    EXECUTE FUNCTION handle_privilege_level();
    """
  end

  def down do
    # Drop the updated trigger and function
    execute """
    DROP TRIGGER IF EXISTS add_to_admin_or_manager ON Users;
    """

    execute """
    DROP FUNCTION IF EXISTS handle_privilege_level();
    """

    # Optionally, recreate the old function and trigger if necessary
    execute """
    CREATE OR REPLACE FUNCTION handle_privilege_level()
    RETURNS TRIGGER AS $$
    BEGIN
        IF NEW.privilege_level = 2 THEN
            INSERT INTO Admin (name, email, password_hash, inserted_at, updated_at)
            VALUES (NEW.username, NEW.email, NEW.password, NEW.inserted_at, NEW.updated_at)
            ON CONFLICT (id) DO NOTHING;

            DELETE FROM Manager WHERE id = NEW.id;

        ELSIF NEW.privilege_level = 1 THEN
            INSERT INTO Manager (name, email, password_hash, inserted_at, updated_at)
            VALUES (NEW.username, NEW.email, NEW.password, NEW.inserted_at, NEW.updated_at)
            ON CONFLICT (id) DO NOTHING;

            DELETE FROM Admin WHERE admin_id = NEW.id;

        ELSE
            DELETE FROM Admin WHERE id = NEW.id;
            DELETE FROM Manager WHERE id = NEW.id;
        END IF;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
    """

    execute """
    CREATE TRIGGER add_to_admin_or_manager
    AFTER INSERT OR UPDATE OF privilege_level
    ON Users
    FOR EACH ROW
    EXECUTE FUNCTION handle_privilege_level();
    """
  end
end
