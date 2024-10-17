defmodule TodolistWeb.TeamController do
  use TodolistWeb, :controller

  alias Todolist.TeamManager
  alias Todolist.TeamManager.Team

  action_fallback TodolistWeb.FallbackController

  # Action to list for a specific user all his teams

  def index_teams_for_user(conn, %{"userID" => user_id}) do
    teams = TeamManager.list_teams_for_user(user_id)
    render(conn, :index, teams: teams)
  end

  def index(conn, _params) do
    teams = TeamManager.list_teams()
    render(conn, :index, teams: teams)
  end

  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- TeamManager.create_team(team_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/teams/#{team}")
      |> render(:show, team: team)
    end
  end

  def show(conn, %{"id" => id}) do
    team = TeamManager.get_team!(id)
    render(conn, :show, team: team)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = TeamManager.get_team!(id)

    with {:ok, %Team{} = team} <- TeamManager.update_team(team, team_params) do
      render(conn, :show, team: team)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = TeamManager.get_team!(id)

    with {:ok, %Team{}} <- TeamManager.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end
end
