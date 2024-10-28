defmodule TodolistWeb.TeamUserController do
  use TodolistWeb, :controller
  import Ecto.Query, only: [from: 2]
  alias Todolist.TeamManager
  alias Todolist.TeamManager.TeamUser
  alias Todolist.TeamManager.Team
  alias Todolist.Accounts.User
  alias Todolist.Repo

  action_fallback TodolistWeb.FallbackController

  # ========================
  #          GET
  # ========================

  # Liste tous les team_users
  def index(conn, _params) do
    teamusers = TeamManager.list_teamusers()                      # Récupère tous les team_users
    render(conn, :index, teamusers: teamusers)                    # Affiche les team_users en JSON
  end

  # Liste tous les utilisateurs d'une équipe spécifique
  def index_users(conn, %{"teamID" => team_id}) do
    team_users =
      Repo.all(
        from tu in TeamUser,
        where: tu.team_id == ^team_id,
        select: tu.user_id
      )                                                           # IDs des utilisateurs dans l'équipe

    if team_users == [] do
      conn
      |> put_status(:not_found)
      |> json(%{error: "No users found for the given team."})     # Erreur si aucun utilisateur n'est trouvé
    else
      users =
        Repo.all(
          from u in User,
          where: u.id in ^team_users
        )                                                         # Récupère les utilisateurs basés sur leurs IDs

      conn
      |> put_status(:ok)
      |> json(users)                                              # Affiche les utilisateurs en JSON
    end
  end

  # Liste toutes les équipes auxquelles un utilisateur spécifique appartient
  def index_teams(conn, %{"userID" => user_id}) do
    team_users =
      Repo.all(
        from tu in TeamUser,
        where: tu.user_id == ^user_id,
        select: tu.team_id
      )                                                           # IDs des équipes pour cet utilisateur

    if team_users == [] do
      conn
      |> put_status(:not_found)
      |> json(%{error: "No teams found for the given user."})     # Erreur si aucune équipe n'est trouvée
    else
      teams =
        Repo.all(
          from t in Team,
          where: t.id in ^team_users
        )                                                         # Récupère les équipes basées sur leurs IDs

      conn
      |> put_status(:ok)
      |> json(teams)                                              # Affiche les équipes en JSON
    end
  end

  # Liste les managers de toutes les équipes auxquelles un utilisateur appartient
  def list_user_managers(conn, %{"userID" => user_id}) do
    teams =
      Repo.all(
        from tu in TeamUser,
        join: t in Team, on: tu.team_id == t.id,
        where: tu.user_id == ^user_id,
        select: t.manager_id
      )                                                           # IDs des managers de cet utilisateur

    if teams == [] do
      conn
      |> put_status(:not_found)
      |> json(%{error: "Cet utilisateur n'appartient à aucune équipe."})  # Erreur si aucun manager n'est trouvé
    else
      managers =
        Repo.all(
          from m in User,
          where: m.id in ^teams,
          select: %{id: m.id, username: m.username, email: m.email}
        )                                                         # Récupère les informations des managers

      conn
      |> put_status(:ok)
      |> json(%{data: managers})                                  # Affiche les managers en JSON
    end
  end

  # ========================
  #         POST
  # ========================

  # Crée une nouvelle association entre un utilisateur et une équipe
  def create(conn, %{"team_user" => team_user_params}) do
    with {:ok, %TeamUser{} = team_user} <- TeamManager.create_team_user(team_user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/teamusers/#{team_user}") # Emplacement de la nouvelle ressource
      |> render(:show, team_user: team_user)                           # Affiche l'association créée
    end
  end

  # ========================
  #         GET (SHOW)
  # ========================

  # Affiche une association spécifique entre utilisateur et équipe
  def show(conn, %{"id" => id}) do
    team_user = TeamManager.get_team_user!(id)                     # Récupère une association par ID
    render(conn, :show, team_user: team_user)                      # Affiche l'association
  end

  # ========================
  #         PUT
  # ========================

  # Met à jour une association spécifique entre utilisateur et équipe
  def update(conn, %{"id" => id, "team_user" => team_user_params}) do
    team_user = TeamManager.get_team_user!(id)                     # Récupère l'association par ID

    with {:ok, %TeamUser{} = team_user} <- TeamManager.update_team_user(team_user, team_user_params) do
      render(conn, :show, team_user: team_user)                    # Affiche l'association mise à jour
    end
  end

  # ========================
  #        DELETE
  # ========================

  # Supprime une association entre utilisateur et équipe
  def delete(conn, %{"id" => id}) do
    team_user = TeamManager.get_team_user!(id)                     # Récupère l'association par ID

    with {:ok, %TeamUser{}} <- TeamManager.delete_team_user(team_user) do
      send_resp(conn, :no_content, "")                             # Suppression réussie, réponse vide
    end
  end
end
