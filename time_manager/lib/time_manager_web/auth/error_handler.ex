defmodule TodolistWeb.Auth.ErrorHandler do
  import Plug.Conn
  import Phoenix.Controller

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: "You are not authenticated."})
    |> halt()
  end

  def unauthorized(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> json(%{error: "You are not authorized to access this resource."})
    |> halt()
  end

  # Optionally, add a handle_errors function if you want to handle different types of errors.
  def handle_errors(conn, {type, reason}) do
    case {type, reason} do
      {:invalid_token, _} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid token."})
        |> halt()

      _ ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "An internal server error occurred."})
        |> halt()
    end
  end

  def auth_error(conn, {type, reason}, _opts) do
    conn
    |> put_status(:unauthorized)  # You can also use :forbidden depending on your logic
    |> json(%{error: to_string(type), reason: to_string(reason)})  # Respond with a JSON object
    |> halt()  # Stop further processing of the connection
  end
end
