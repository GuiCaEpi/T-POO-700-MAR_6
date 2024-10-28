defmodule TodolistWeb.ClockController do
  use TodolistWeb, :controller

  alias Todolist.Clocking
  alias Todolist.Clocking.Clock

  action_fallback TodolistWeb.FallbackController

  def index(conn, %{"userID" => user_id}) do
    clocks = Clocking.get_clocks_by_user_id(user_id)

    if clocks == [] do
      conn
      |> put_status(:not_found)
      |> json(%{error: "User not found or no clocks recorded for this user."})
    else
      render(conn, :index, clocks: clocks)
    end
  end

  # def index(conn, _params) do
  #   clocks = Clocking.list_clocks()
  #   render(conn, :index, clocks: clocks)
  # end

  def create(conn, %{"userID" => user_id, "clock" => clock_params}) do
    clock_params = Map.put(clock_params, "user_id", user_id)

    # Supposons qu'il y ait une équipe ID liée au clock, et vérifie si l'utilisateur appartient à l'équipe
    team_id = Map.get(clock_params, "team_id")

    if Accounts.user_belongs_to_team?(user_id, team_id) do
      case Clocking.create_clock(clock_params) do
        {:ok, clock} ->
          conn
          |> put_status(:created)
          |> render(:show, clock: clock)

        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(TodolistWeb.ChangesetView, "error.json", changeset: changeset)
      end
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "User does not belong to the specified team."})
      |> halt()
    end
  end


  def show(conn, %{"id" => id}) do
    clock = Clocking.get_clock!(id)
    render(conn, :show, clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Clocking.get_clock!(id)

    # Vérification du champ `status`
    if Map.get(clock_params, "status", "") == "" do
      conn
      |> put_status(:unprocessable_entity)
      |> json(%{error: "Status cannot be empty."})
      |> halt()
    else
      with {:ok, %Clock{} = updated_clock} <- Clocking.update_clock(clock, clock_params) do
        render(conn, :show, clock: updated_clock)
      end
    end
  end


  def delete(conn, %{"id" => id}) do
    clock = Clocking.get_clock!(id)

    with {:ok, %Clock{}} <- Clocking.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
