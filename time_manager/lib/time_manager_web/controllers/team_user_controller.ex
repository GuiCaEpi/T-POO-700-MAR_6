defmodule TodolistWeb.TeamUserController do
  use TodolistWeb, :controller

  alias Todolist.TeamManager
  alias Todolist.TeamManager.TeamUser

  action_fallback TodolistWeb.FallbackController

  def index(conn, _params) do
    teamusers = TeamManager.list_teamusers()
    render(conn, :index, teamusers: teamusers)
  end

  def create(conn, %{"team_user" => team_user_params}) do
    with {:ok, %TeamUser{} = team_user} <- TeamManager.create_team_user(team_user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/teamusers/#{team_user}")
      |> render(:show, team_user: team_user)
    end
  end

  def show(conn, %{"id" => id}) do
    team_user = TeamManager.get_team_user!(id)
    render(conn, :show, team_user: team_user)
  end

  def update(conn, %{"id" => id, "team_user" => team_user_params}) do
    team_user = TeamManager.get_team_user!(id)

    with {:ok, %TeamUser{} = team_user} <- TeamManager.update_team_user(team_user, team_user_params) do
      render(conn, :show, team_user: team_user)
    end
  end

  def delete(conn, %{"id" => id}) do
    team_user = TeamManager.get_team_user!(id)

    with {:ok, %TeamUser{}} <- TeamManager.delete_team_user(team_user) do
      send_resp(conn, :no_content, "")
    end
  end
end
