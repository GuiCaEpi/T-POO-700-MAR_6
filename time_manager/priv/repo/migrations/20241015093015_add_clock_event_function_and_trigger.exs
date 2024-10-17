defmodule Todolist.Repo.Migrations.AddClockEventFunctionAndTrigger do
  use Ecto.Migration
  def up do
    # Créer la fonction handle_clock_event()
    execute """
    CREATE OR REPLACE FUNCTION handle_clock_event()
    RETURNS TRIGGER AS $$
    BEGIN
        IF NEW.status = true THEN
            INSERT INTO WorkingTimes (user_id, start_time, team_id, inserted_at, updated_at)
            VALUES (NEW.user_id, NEW.time, NEW.team_id, NOW(), NOW());
        ELSE
            UPDATE WorkingTimes
            SET end_time = NEW.time,
                updated_at = NOW()
            WHERE user_id = NEW.user_id
              AND end_time IS NULL;
        END IF;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
    """

    # Créer le trigger clock_event_trigger pour la table clocks
    execute """
    CREATE TRIGGER clock_event_trigger
    AFTER INSERT
    ON clocks
    FOR EACH ROW
    EXECUTE FUNCTION handle_clock_event();
    """
  end

  def down do
    # Supprimer le trigger clock_event_trigger
    execute """
    DROP TRIGGER IF EXISTS clock_event_trigger ON clocks;
    """

    # Supprimer la fonction handle_clock_event()
    execute """
    DROP FUNCTION IF EXISTS handle_clock_event();
    """
  end
end
