defmodule TodolistWeb.Plugs.RoleAuthorization do
  import Plug.Conn
  import Phoenix.Controller

  def init(default), do: default

  def call(conn, required_privilege_level) do

    claims = Guardian.Plug.current_claims(conn)

    case Guardian.Plug.current_claims(conn) do
      %{"privilege_level" => privilege_level} when privilege_level >= required_privilege_level ->
        IO.puts("Access granted. User privilege level: #{privilege_level}")
        conn  # Allow access if privilege level is sufficient
      _ ->
        conn
        |> put_status(:forbidden)  # Insufficient privileges
        |> json(%{error: "You are not authorized to access this resource."})
        |> halt()
    end
  end
end
