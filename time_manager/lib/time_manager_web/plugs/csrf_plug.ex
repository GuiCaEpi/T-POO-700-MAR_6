defmodule TodolistWeb.Plugs.CSRFPlug do
  import Plug.Conn
  import Phoenix.Controller
  alias TodolistWeb.Auth.Guardian

  def init(default), do: default

  def call(conn, _opts) do
    case Guardian.Plug.current_resource(conn) do
      {_user, csrf_token_from_claims} ->
        request_csrf_token = get_req_header(conn, "x-csrf-token") |> List.first()

        if Guardian.validate_csrf_token(request_csrf_token, csrf_token_from_claims) do
          conn
        else
          conn
          |> put_status(:forbidden)
          |> json(%{error: "CSRF token mismatch"})
          |> halt()
        end

      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "No valid token provided"})
        |> halt()
    end
  end
end
