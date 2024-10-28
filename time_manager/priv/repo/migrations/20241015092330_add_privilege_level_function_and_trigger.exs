defmodule Todolist.Repo.Migrations.AddPrivilegeLevelFunctionAndTrigger do
  use Ecto.Migration

  def up do
    # Créer la fonction handle_privilege_level()
    execute """
    CREATE OR REPLACE FUNCTION handle_privilege_level()
    RETURNS TRIGGER AS $$
    BEGIN
        IF NEW.privilege_level = 2 THEN
            INSERT INTO Admin (admin_id, name, email, password, created_at)
            VALUES (NEW.user_id, NEW.name, NEW.email, NEW.password, NEW.created_at)
            ON CONFLICT (admin_id) DO NOTHING;

            DELETE FROM Manager WHERE manager_id = NEW.user_id;

        ELSIF NEW.privilege_level = 1 THEN
            INSERT INTO Manager (manager_id, name, email, password, created_at)
            VALUES (NEW.user_id, NEW.name, NEW.email, NEW.password, NEW.created_at)
            ON CONFLICT (manager_id) DO NOTHING;

            DELETE FROM Admin WHERE admin_id = NEW.user_id;

        ELSE
            DELETE FROM Admin WHERE admin_id = NEW.user_id;
            DELETE FROM Manager WHERE manager_id = NEW.user_id;
        END IF;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
    """

    # Créer le trigger add_to_admin_or_manager
    execute """
    CREATE TRIGGER add_to_admin_or_manager
    AFTER INSERT OR UPDATE OF privilege_level
    ON Users
    FOR EACH ROW
    EXECUTE FUNCTION handle_privilege_level();
    """
  end

  def down do
    # Supprimer le trigger
    execute """
    DROP TRIGGER IF EXISTS add_to_admin_or_manager ON Users;
    """

    # Supprimer la fonction handle_privilege_level()
    execute """
    DROP FUNCTION IF EXISTS handle_privilege_level();
    """
  end
end
