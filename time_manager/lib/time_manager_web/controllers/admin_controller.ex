defmodule TodolistWeb.AdminController do
  use TodolistWeb, :controller

  alias Todolist.Accounts
  alias Todolist.Accounts.Admin

  action_fallback TodolistWeb.FallbackController

  def index(conn, _params) do
    admins = Accounts.list_admins()
    render(conn, :index, admins: admins)
  end

  def create(conn, %{"admin" => admin_params}) do
    with {:ok, %Admin{} = admin} <- Accounts.create_admin(admin_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/admins/#{admin}")
      |> render(:show, admin: admin)
    end
  end

  def show(conn, %{"id" => id}) do
    admin = Accounts.get_admin!(id)
    render(conn, :show, admin: admin)
  end

  def update(conn, %{"id" => id, "admin" => admin_params}) do
    admin = Accounts.get_admin!(id)

    with {:ok, %Admin{} = admin} <- Accounts.update_admin(admin, admin_params) do
      render(conn, :show, admin: admin)
    end
  end

  def delete(conn, %{"id" => id}) do
    admin = Accounts.get_admin!(id)

    with {:ok, %Admin{}} <- Accounts.delete_admin(admin) do
      send_resp(conn, :no_content, "")
    end
  end
end
