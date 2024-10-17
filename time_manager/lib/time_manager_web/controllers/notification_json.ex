defmodule TodolistWeb.NotificationJSON do
  alias Todolist.RequestNotification.Notification

  @doc """
  Renders a list of notifications.
  """
  def index(%{notifications: notifications}) do
    %{data: for(notification <- notifications, do: data(notification))}
  end

  @doc """
  Renders a single notification.
  """
  def show(%{notification: notification}) do
    %{data: data(notification)}
  end

  defp data(%Notification{} = notification) do
    %{
      id: notification.id,
      message: notification.message,
      is_read: notification.is_read
    }
  end
end
