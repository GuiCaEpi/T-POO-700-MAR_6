# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Todolist.Repo.insert!(%Todolist.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Todolist.Repo.insert!(%Todolist.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


defmodule Todolist.Seeds do
  alias Todolist.Repo
  alias Todolist.Accounts.Admin
  alias Todolist.TeamManager.Team
  alias Todolist.TeamManager.TeamUser
  alias Todolist.Accounts.Manager
  alias Todolist.Accounts.User
  alias Todolist.Clocking.Clock
  alias Todolist.Work.WorkingTime
  alias Todolist.RequestNotification.CorrectionRequest


  import Ecto.Query
  # Function de delete all records in the database

  def delete_all_records do
    # Repo.delete_all(User)
    Repo.delete_all(CorrectionRequest)
    Repo.delete_all(Clock)
    Repo.delete_all(WorkingTime)
    Repo.delete_all(TeamUser)
    Repo.delete_all(Team)
    Repo.delete_all(Manager)
    Repo.delete_all(Admin)
    Repo.delete_all(User)
  end

  # Function to create fake admins
  def create_fake_admins do
    for _ <- 1..5 do
      %Admin{
        name: Faker.Person.name(),
        email: Faker.Internet.email(),
        password_hash: "hashed_password"
      }
      |> Repo.insert!()
    end
  end

  # Function to create fake managers

  def create_fake_managers do

    for _ <- 1..30 do
      %Manager{
        name: Faker.Person.name(),
        email: Faker.Internet.email(),
        password_hash: "hashed_password",
      }
      |> Repo.insert!()
    end
  end

  # Function to create fake users

  def create_fake_users do

      for _ <- 1..300 do
        %User{
          username: Faker.Person.name(),
          email: Faker.Internet.email(),
          password: "hashed_password",
          privilege_level: 0
        }
        |> Repo.insert!()
      end
    end

  # Function to create fake teams

  def create_fake_teams do
    manager_ids = Repo.all(from m in Manager, select: m.id)

    for _ <- 1..30 do
      %Team{
        name: Faker.Team.name(),
        manager_id: Enum.random(manager_ids)
      }
      |> Repo.insert!()
    end
  end

  # Function to create new team_users

  def create_fake_team_users do

    user_ids = Repo.all(from u in User, select: u.id)
    team_ids = Repo.all(from t in Team, select: t.id)

    for _ <- 1..900 do
      %TeamUser{
        user_id: Enum.random(user_ids),
        team_id: Enum.random(team_ids)
      }
      |> Repo.insert!()
    end
  end

  def create_fake_clocks do
    users_with_teams = Repo.all(from tu in TeamUser, preload: [:team, :user])

    for _ <- 1..1000 do
      team_user = Enum.random(users_with_teams)
      clock_in_time = Faker.DateTime.backward(15)  # Random time in the last 15 days
      clock_out_time = Faker.DateTime.forward(1)  # At least 1 hour after clock-in

      clock_in_time = DateTime.truncate(clock_in_time, :second)
      clock_out_time = DateTime.truncate(clock_out_time, :second)

      %Clock{
        time: clock_in_time,
        user_id: team_user.user_id,
        team_id: team_user.team_id,
        status: true  # Clock in
      }
      |> Repo.insert!()

      %Clock{
        time: clock_out_time,
        user_id: team_user.user_id,
        team_id: team_user.team_id,
        status: false  # Clock out
      }
      |> Repo.insert!()
    end
  end

  def create_fake_correction_requests do
    # Get all team users to associate users with teams
    team_users = Repo.all(from tu in TeamUser, preload: [:user, :team])

    for _ <- 1..10 do
      # Select a random team user
      team_user = Enum.random(team_users)
      user_id = team_user.user_id
      team_id = team_user.team_id

      # Get the manager for the team
      manager_id = Repo.one(from t in Team, where: t.id == ^team_id, select: t.manager_id)

      # Get the clocks for the user and the team
      clock_ids = Repo.all(from c in Clock, where: c.user_id == ^user_id and c.team_id == ^team_id, select: c.id)

      # Ensure there is at least one clock available for the user and team
      if clock_ids != [] do
        # Select a random clock ID
        clock_id = Enum.random(clock_ids)

        # Create the correction request
        %CorrectionRequest{
          request_message: Faker.Lorem.sentence(), # Generate a random request message
          status: Enum.random(["pending", "approved", "rejected"]), # Randomly select a status
          user_id: user_id, # The selected user's ID
          clock_id: clock_id, # The selected clock's ID
          manager_id: manager_id # The manager's ID
        }
        |> Repo.insert!() # Insert the correction request into the database
      end
    end
  end

end

# Call the function outside the module context
Todolist.Seeds.delete_all_records()
Todolist.Seeds.create_fake_admins()
Todolist.Seeds.create_fake_managers()
Todolist.Seeds.create_fake_users()
Todolist.Seeds.create_fake_teams()
Todolist.Seeds.create_fake_team_users()
Todolist.Seeds.create_fake_clocks()
Todolist.Seeds.create_fake_correction_requests()
