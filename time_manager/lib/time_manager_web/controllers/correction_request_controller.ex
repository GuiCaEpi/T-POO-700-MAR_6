defmodule TodolistWeb.CorrectionRequestController do
  use TodolistWeb, :controller
  alias Todolist.RequestNotification
  alias Todolist.RequestNotification.CorrectionRequest

  action_fallback TodolistWeb.FallbackController

  # User actions
  # 1 - Function to create a new request for a specific user;

  def create(conn, %{"userID" => user_id, "correction_request" => correction_request_params}) do
    correction_request_params = Map.put(correction_request_params, "user_id", user_id)

    case RequestNotification.create_correction_request(correction_request_params) do
      {:ok, correction_request} ->
        conn
        |> put_status(:created)
        |> render("show.json", correction_request: correction_request)
    end
  end

  # 2 - Function to show a specific requests for a specific user

  def show_user(conn, %{"userID" => user_id, "id" => id}) do
    case RequestNotification.get_request_by_user_and_id(user_id, id) do
      nil ->
        send_resp(conn, :not_found, "Request not found")

      correction_request ->
        render(conn, "show.json", correction_request: correction_request)
    end
  end

    # 3 - Function to show a all requests for a specific user

  def index_user(conn, %{"userID" => user_id}) do
    correction_requests = RequestNotification.get_requests_by_user_id(user_id)
    render(conn, :index, correction_requests: correction_requests)
  end

  # Manager actions
  # 1 - Function to list all correction requests for the manager

  def index_manager(conn, %{"managerID" => manager_id}) do
    correction_requests = RequestNotification.get_requests_by_manager_id(manager_id)
    render(conn, :index, correction_requests: correction_requests)
  end

  # 2 - Function to fetch and render a specific correction request for the manager

  def show_manager(conn, %{"managerID" => manager_id, "id" => id}) do
    case RequestNotification.get_request_by_manager_and_id(manager_id, id) do
      nil ->
        send_resp(conn, :not_found, "Request not found")

      correction_request ->
        render(conn, "show.json", correction_request: correction_request)
    end
  end

  # 3 - Function to update a correction request as the manager


  def update_manager(conn, %{"managerID" => manager_id, "id" => id, "correction_request" => correction_request_params}) do
    correction_request = RequestNotification.get_correction_request_by_manager_and_id(manager_id, id)
    with {:ok, %CorrectionRequest{} = correction_request} <- RequestNotification.update_correction_request(correction_request, correction_request_params) do
      render(conn, :show, correction_request: correction_request)
    end
  end

  # Classic actions

  def index(conn, _params) do
    correction_requests = RequestNotification.list_correctionrequests()
    render(conn, :index, correction_requests: correction_requests)
  end

  def create(conn, %{"correction_request" => correction_request_params}) do
    with {:ok, %CorrectionRequest{} = correction_request} <- RequestNotification.create_correction_request(correction_request_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/correctionrequests/#{correction_request}")
      |> render(:show, correction_request: correction_request)
    end
  end

  def show(conn, %{"id" => id}) do
    correction_request = RequestNotification.get_correction_request!(id)
    render(conn, :show, correction_request: correction_request)
  end

  def update(conn, %{"id" => id, "correction_request" => correction_request_params}) do
    correction_request = RequestNotification.get_correction_request!(id)

    with {:ok, %CorrectionRequest{} = correction_request} <- RequestNotification.update_correction_request(correction_request, correction_request_params) do
      render(conn, :show, correction_request: correction_request)
    end
  end

  def delete(conn, %{"id" => id}) do
    correction_request = RequestNotification.get_correction_request!(id)

    with {:ok, %CorrectionRequest{}} <- RequestNotification.delete_correction_request(correction_request) do
      send_resp(conn, :no_content, "")
    end
  end
end
