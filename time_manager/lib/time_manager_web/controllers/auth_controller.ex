defmodule TodolistWeb.AuthController do
  use TodolistWeb, :controller

  alias Todolist.Accounts
  alias TodolistWeb.Auth.Guardian
  alias TodolistWeb.Plugs.CSRFPlug



  def sign_up(conn, %{"username" => username, "email" => email, "password" => password}) do
    case Accounts.create_user(%{
           username: username,
           email: email,
           password_hash: password
         }) do
      {:ok, user} ->
        case Guardian.encode_and_sign(user) do
          {:ok, token, _claims} ->
            conn
            |> put_status(:created)
            |> json(%{token: token, user: %{id: user.id, email: user.email, username: user.username}})

          {:error, reason} ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{error: "Failed to generate token: #{reason}"})
        end
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:ok, user, token, csrf_token} ->
        conn
        |> put_resp_cookie("jwt", token, http_only: true, secure: true)
        |> put_resp_cookie("x-csrf-token", csrf_token, http_only: true, secure: true)

        |> put_status(:ok)
        |> json(%{
          user: %{id: user.id, email: user.email, username: user.username, token: token},
        })

      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: reason})
    end
  end

  def sign_out(conn, _params) do
    auth_header = get_req_header(conn, "authorization")

    case auth_header do
      ["Bearer " <> token] ->
        case Guardian.revoke(token) do
          {:ok, _} ->
            conn
            |> put_status(:ok)
            |> json(%{message: "Signed out successfully"})

          {:error, reason} ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{error: reason})
        end

      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "No valid token provided"})
    end
  end

  defp verify_csrf_token(conn, _opts) do
    case Guardian.Plug.current_resource(conn) do
      {user, csrf_token_from_claims} ->
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

      plug :verify_csrf_token when action in [:protected_action]

  def protected_action(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{message: "You have access to this route"})
  end

end
