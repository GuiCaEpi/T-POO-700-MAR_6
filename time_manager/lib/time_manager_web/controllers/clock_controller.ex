defmodule TodolistWeb.ClockController do
  use TodolistWeb, :controller

  alias Todolist.Clocking
  alias Todolist.Clocking.Clock

  action_fallback TodolistWeb.FallbackController

  def index(conn, %{"userID" => user_id}) do
    clocks = Clocking.get_clocks_by_user_id(user_id)
    render(conn, :index, clocks: clocks)
  end

  # def index(conn, _params) do
  #   clocks = Clocking.list_clocks()
  #   render(conn, :index, clocks: clocks)
  # end

  def create(conn, %{"userID" => user_id, "clock" => clock_params}) do
    clock_params = Map.put(clock_params, "user_id", user_id)

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
  end

  def show(conn, %{"id" => id}) do
    clock = Clocking.get_clock!(id)
    render(conn, :show, clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Clocking.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Clocking.update_clock(clock, clock_params) do
      render(conn, :show, clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Clocking.get_clock!(id)

    with {:ok, %Clock{}} <- Clocking.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
