defmodule TodolistWeb.TeamController do
  use TodolistWeb, :controller

  alias Todolist.TeamManager
  alias Todolist.TeamManager.Team

  action_fallback TodolistWeb.FallbackController

  # ========================
  #          GET
  # ========================

  # Liste toutes les équipes d'un manager spécifique
  def index_teams_for_manager(conn, %{"managerID" => manager_id}) do
    teams = TeamManager.list_teams_for_manager(manager_id)                 # Récupère les équipes pour un manager donné
    render(conn, :index, teams: teams)                                     # Affiche les équipes en JSON
  end

  # Liste toutes les équipes auxquelles un utilisateur spécifique appartient
  def index_teams_for_user(conn, %{"userID" => user_id}) do
    teams = TeamManager.list_teams_for_user(user_id)                       # Récupère les équipes pour un utilisateur donné
    render(conn, :index, teams: teams)                                     # Affiche les équipes en JSON
  end

  # Liste toutes les équipes
  def index(conn, _params) do
    teams = TeamManager.list_teams()                                       # Récupère toutes les équipes
    render(conn, :index, teams: teams)                                     # Affiche les équipes en JSON
  end

  # ========================
  #         POST
  # ========================

  # Crée une nouvelle équipe
  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- TeamManager.create_team(team_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/teams/#{team}")               # Emplacement de la nouvelle équipe
      |> render(:show, team: team)                                         # Affiche l'équipe créée
    end
  end

  # ========================
  #         GET (SHOW)
  # ========================

  # Affiche une équipe spécifique
  def show(conn, %{"id" => id}) do
    team = TeamManager.get_team!(id)                                       # Récupère une équipe par ID
    render(conn, :show, team: team)                                        # Affiche l'équipe
  end

  # ========================
  #         PUT
  # ========================

  # Met à jour une équipe spécifique
  def update(conn, %{"id" => id, "team" => team_params}) do
    team = TeamManager.get_team!(id)                                       # Récupère l'équipe par ID

    with {:ok, %Team{} = team} <- TeamManager.update_team(team, team_params) do
      render(conn, :show, team: team)                                      # Affiche l'équipe mise à jour
    end
  end

  # ========================
  #        DELETE
  # ========================

  # Supprime une équipe spécifique
  def delete(conn, %{"id" => id}) do
    team = TeamManager.get_team!(id)                                       # Récupère l'équipe par ID

    with {:ok, %Team{}} <- TeamManager.delete_team(team) do
      send_resp(conn, :no_content, "")                                     # Réponse vide après suppression réussie
    end
  end
end
