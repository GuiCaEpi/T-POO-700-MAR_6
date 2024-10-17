defmodule TodolistWeb.NotificationController do
  use TodolistWeb, :controller

  alias Todolist.RequestNotification
  alias Todolist.RequestNotification.Notification

  action_fallback TodolistWeb.FallbackController

  def index(conn, _params) do
    notifications = RequestNotification.list_notifications()
    render(conn, :index, notifications: notifications)
  end

  def create(conn, %{"notification" => notification_params}) do
    with {:ok, %Notification{} = notification} <- RequestNotification.create_notification(notification_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/notifications/#{notification}")
      |> render(:show, notification: notification)
    end
  end

  def show(conn, %{"id" => id}) do
    notification = RequestNotification.get_notification!(id)
    render(conn, :show, notification: notification)
  end

  def update(conn, %{"id" => id, "notification" => notification_params}) do
    notification = RequestNotification.get_notification!(id)

    with {:ok, %Notification{} = notification} <- RequestNotification.update_notification(notification, notification_params) do
      render(conn, :show, notification: notification)
    end
  end

  def delete(conn, %{"id" => id}) do
    notification = RequestNotification.get_notification!(id)

    with {:ok, %Notification{}} <- RequestNotification.delete_notification(notification) do
      send_resp(conn, :no_content, "")
    end
  end
end
