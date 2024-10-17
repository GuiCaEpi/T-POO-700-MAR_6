defmodule Todolist.TeamManagerTest do
  use Todolist.DataCase

  alias Todolist.TeamManager

  describe "teams" do
    alias Todolist.TeamManager.Team

    import Todolist.TeamManagerFixtures

    @invalid_attrs %{name: nil}

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert TeamManager.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert TeamManager.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Team{} = team} = TeamManager.create_team(valid_attrs)
      assert team.name == "some name"
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TeamManager.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Team{} = team} = TeamManager.update_team(team, update_attrs)
      assert team.name == "some updated name"
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = TeamManager.update_team(team, @invalid_attrs)
      assert team == TeamManager.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = TeamManager.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> TeamManager.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = TeamManager.change_team(team)
    end
  end

  describe "teamusers" do
    alias Todolist.TeamManager.TeamUser

    import Todolist.TeamManagerFixtures

    @invalid_attrs %{}

    test "list_teamusers/0 returns all teamusers" do
      team_user = team_user_fixture()
      assert TeamManager.list_teamusers() == [team_user]
    end

    test "get_team_user!/1 returns the team_user with given id" do
      team_user = team_user_fixture()
      assert TeamManager.get_team_user!(team_user.id) == team_user
    end

    test "create_team_user/1 with valid data creates a team_user" do
      valid_attrs = %{}

      assert {:ok, %TeamUser{} = team_user} = TeamManager.create_team_user(valid_attrs)
    end

    test "create_team_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TeamManager.create_team_user(@invalid_attrs)
    end

    test "update_team_user/2 with valid data updates the team_user" do
      team_user = team_user_fixture()
      update_attrs = %{}

      assert {:ok, %TeamUser{} = team_user} = TeamManager.update_team_user(team_user, update_attrs)
    end

    test "update_team_user/2 with invalid data returns error changeset" do
      team_user = team_user_fixture()
      assert {:error, %Ecto.Changeset{}} = TeamManager.update_team_user(team_user, @invalid_attrs)
      assert team_user == TeamManager.get_team_user!(team_user.id)
    end

    test "delete_team_user/1 deletes the team_user" do
      team_user = team_user_fixture()
      assert {:ok, %TeamUser{}} = TeamManager.delete_team_user(team_user)
      assert_raise Ecto.NoResultsError, fn -> TeamManager.get_team_user!(team_user.id) end
    end

    test "change_team_user/1 returns a team_user changeset" do
      team_user = team_user_fixture()
      assert %Ecto.Changeset{} = TeamManager.change_team_user(team_user)
    end
  end
end
