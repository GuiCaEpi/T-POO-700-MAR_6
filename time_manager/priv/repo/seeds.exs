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
    for _ <- 1..10 do
      Todolist.Accounts.create_user(%{
        username: Faker.Person.name(),
        email: Faker.Internet.email(),
        privilege_level: 2,
        password_hash: "hashed_password"
      })
      end
  end

  # Function to create fake managers

  def create_fake_managers do
    for _ <- 1..30 do
      case Todolist.Accounts.create_user(%{
        username: Faker.Person.name(),
        email: Faker.Internet.email(),
        privilege_level: 1,
        password_hash: "hashed_password"
      }) do
        {:ok, user} -> IO.puts("Created manager #{user.username}")
        {:error, changeset} -> IO.inspect(changeset, label: "Manager creation failed")
      end
    end
  end

  # Function to create fake users

  def create_fake_users do

    for _ <- 1..300 do
    Todolist.Accounts.create_user(%{
      username: Faker.Person.name(),
      email: Faker.Internet.email(),
      privilege_level: 0,
      password_hash: "hashed_password"
    })
    end
  end


  def create_fake_teams do
    manager_ids = Repo.all(from u in User, where: u.privilege_level == 1, select: u.id)

    for manager_id <- manager_ids do
      team_exists = Repo.one(from t in Team, where: t.manager_id == ^manager_id, select: t.id)

      unless team_exists do
        %Team{
          name: Faker.Team.name(),
          manager_id: manager_id
        }
        |> Repo.insert!()

        IO.puts("Created team for manager #{manager_id}")
      else
        IO.puts("Manager #{manager_id} already has a team.")
      end
    end
  end

  # Function to create new team_users

  # def create_fake_team_users do

  #   user_ids = Repo.all(from u in User, where: u.privilege_level == 0, select: u.id)
  #   team_ids = Repo.all(from t in Team, select: t.id)

  #   for _ <- 1..900 do
  #     %TeamUser{
  #       user_id: Enum.random(user_ids),
  #       team_id: Enum.random(team_ids)
  #     }
  #     |> Repo.insert!()
  #   end
  # end

  def create_fake_team_users do
    user_ids = Repo.all(from u in User, where: u.privilege_level == 0, select: u.id)
    team_ids = Repo.all(from t in Team, select: t.id)

    for _ <- 1..900 do
      user_id = Enum.random(user_ids)
      team_id = Enum.random(team_ids)

      existing_team_user = Repo.one(from tu in TeamUser,
                                    where: tu.user_id == ^user_id and tu.team_id == ^team_id)

      if is_nil(existing_team_user) do
        %TeamUser{
          user_id: user_id,
          team_id: team_id
        }
        |> Repo.insert!()
      end
    end
  end


  def create_fake_clocks do
    users_with_teams = Repo.all(from tu in TeamUser, preload: [:team, :user])

    for _ <- 1..1000 do
      team_user = Enum.random(users_with_teams)
      clock_in_time = Faker.DateTime.backward(15)
      clock_out_time = Faker.DateTime.forward(1)

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
    team_users = Repo.all(from tu in TeamUser, preload: [:user, :team])

    for _ <- 1..10 do
      team_user = Enum.random(team_users)
      user_id = team_user.user_id
      team_id = team_user.team_id

      manager_id = Repo.one(from t in Team, where: t.id == ^team_id, select: t.manager_id)

      clock_ids = Repo.all(from c in Clock, where: c.user_id == ^user_id and c.team_id == ^team_id, select: c.id)

      if clock_ids != [] do
        clock_id = Enum.random(clock_ids)

        %CorrectionRequest{
          request_message: Faker.Lorem.sentence(),
          status: Enum.random(["pending", "approved", "rejected"]),
          user_id: user_id,
          clock_id: clock_id,
          manager_id: manager_id
        }
        |> Repo.insert!()
      end
    end
  end

end

Todolist.Seeds.delete_all_records()
Todolist.Seeds.create_fake_admins()
Todolist.Seeds.create_fake_managers()
Todolist.Seeds.create_fake_users()
Todolist.Seeds.create_fake_teams()
Todolist.Seeds.create_fake_team_users()
Todolist.Seeds.create_fake_clocks()
Todolist.Seeds.create_fake_correction_requests()
