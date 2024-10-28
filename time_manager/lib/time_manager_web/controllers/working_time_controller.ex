defmodule TodolistWeb.WorkingTimeController do
  use TodolistWeb, :controller

  alias Todolist.Work
  alias Todolist.Work.WorkingTime
  alias Todolist.Accounts

  action_fallback TodolistWeb.FallbackController

  # ========================
  #         GET
  # ========================

  # Récupère tous les working times pour un utilisateur spécifique
  def index(conn, %{"userID" => user_id}) do
    working_times = Work.list_working_times_for_user(user_id)    # Liste des working times de l'utilisateur
    render(conn, "index.json", working_times: working_times)
  end

  # Affiche un working time spécifique pour un utilisateur donné
  def show(conn, %{"userID" => user_id, "id" => id}) do
    case Work.get_working_time_by_user_and_id(user_id, id) do
      nil ->
        send_resp(conn, :not_found, "Working time not found")    # Erreur si le working time n'existe pas

      working_time ->
        render(conn, "show.json", working_time: working_time)    # Affiche les détails du working time
    end
  end

  # ========================
  #         POST
  # ========================

  # Crée un nouveau working time pour un utilisateur spécifique
  def create(conn, %{"userID" => user_id, "working_time" => working_time_params}) do
    team_id = Map.get(working_time_params, "team_id")

    # Vérifie si l'utilisateur appartient à l'équipe
    if Accounts.is_user_in_team?(user_id, team_id) do
      working_time_params = Map.put(working_time_params, "user_id", user_id)
      case Work.create_working_time(working_time_params) do
        {:ok, working_time} ->
          conn
          |> put_status(:created)
          |> render("show.json", working_time: working_time)     # Création réussie du working time

        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(TodolistWeb.ChangesetView, "error.json", changeset: changeset)  # Erreur de validation
      end
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "User does not belong to the specified team."})             # Erreur d'appartenance à l'équipe
      |> halt()
    end
  end

  # ========================
  #         PUT
  # ========================

  # Met à jour un working time spécifique pour un utilisateur donné
  def update(conn, %{"userID" => user_id, "id" => workingtime_id, "working_time" => working_time_params}) do
    working_time = Work.get_working_time!(workingtime_id)

    new_team_id = Map.get(working_time_params, "team_id")        # ID de la nouvelle équipe
    current_team_id = working_time.team_id                       # ID de l'équipe actuelle

    if new_team_id && new_team_id != current_team_id && !Accounts.is_user_in_team?(user_id, new_team_id) do
      conn
      |> put_status(:forbidden)
      |> json(%{error: "User does not belong to the specified team. Cannot update working time for this team."}) # Erreur d'appartenance
      |> halt()
    else
      with {:ok, %WorkingTime{} = updated_working_time} <- Work.update_working_time(working_time, working_time_params) do
        render(conn, :show, working_time: updated_working_time)  # Mise à jour réussie du working time
      end
    end
  end

  # ========================
  #        DELETE
  # ========================

  # Supprime un working time par son ID
  def delete(conn, %{"id" => id}) do
    working_time = Work.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Work.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")                           # Suppression réussie du working time
    end
  end
end
