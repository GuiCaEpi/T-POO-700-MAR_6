defmodule TodolistWeb.WorkingTimeController do
  use TodolistWeb, :controller

  alias Todolist.Work
  alias Todolist.Work.WorkingTime

  action_fallback TodolistWeb.FallbackController


  def index(conn, %{"userID" => user_id, "start" => start_time, "end" => end_time}) do
    case DateTime.from_iso8601(start_time) do
      {:ok, start_time_parsed, _offset} ->
        case DateTime.from_iso8601(end_time) do
          {:ok, end_time_parsed, _offset} ->
            working_times = Work.list_working_times_for_user_within_range(user_id, start_time_parsed, end_time_parsed)
            render(conn, "index.json", working_times: working_times)

          {:error, _reason} ->
            conn
            |> put_status(:bad_request)
            |> json(%{error: "Invalid end_time format"})
        end

      {:error, _reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid start_time format"})
    end
  end

  def show(conn, %{"userID" => user_id, "id" => id}) do
    case Work.get_working_time_by_user_and_id(user_id, id) do
      nil ->
        send_resp(conn, :not_found, "Working time not found")

      working_time ->
        render(conn, "show.json", working_time: working_time)
    end
  end


  def create(conn, %{"userID" => user_id, "working_time" => working_time_params}) do
    working_time_params = Map.put(working_time_params, "user_id", user_id)

    case Work.create_working_time(working_time_params) do
      {:ok, working_time} ->
        conn
        |> put_status(:created)
        |> render("show.json", working_time: working_time)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TodolistWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   working_time = Work.get_working_time!(id)
  #   render(conn, :show, working_time: working_time)
  # end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Work.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- Work.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Work.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Work.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
