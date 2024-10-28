defmodule TodolistWeb.UserController do
  use TodolistWeb, :controller

  alias Todolist.Accounts
  alias Todolist.Accounts.User

  action_fallback TodolistWeb.FallbackController

  # ========================
  #         GET
  # ========================

  # Liste les utilisateurs par email et username
  def index(conn, %{"email" => email, "username" => username}) do
    users = Accounts.list_users_by_email_and_username(email, username)
    json(conn, users)
  end

  # Liste les utilisateurs par email
  def index(conn, %{"email" => email}) do
    users = Accounts.list_users_by_email(email)
    json(conn, users)
  end

  # Liste les utilisateurs par username
  def index(conn, %{"username" => username}) do
    users = Accounts.list_users_by_username(username)
    json(conn, users)
  end

  # Liste tous les utilisateurs
  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  # Affiche un utilisateur par son ID
  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  # ========================
  #         POST
  # ========================

  # Crée un nouvel utilisateur
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  # ========================
  #         PUT
  # ========================

  # Met à jour un utilisateur par son ID
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  # ========================
  #        DELETE
  # ========================

  # Supprime un utilisateur par son ID
  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
