defmodule Todolist.RequestNotificationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todolist.RequestNotification` context.
  """

  @doc """
  Generate a correction_request.
  """
  def correction_request_fixture(attrs \\ %{}) do
    {:ok, correction_request} =
      attrs
      |> Enum.into(%{
        request_message: "some request_message",
        status: "some status"
      })
      |> Todolist.RequestNotification.create_correction_request()

    correction_request
  end

  @doc """
  Generate a notification.
  """
  def notification_fixture(attrs \\ %{}) do
    {:ok, notification} =
      attrs
      |> Enum.into(%{
        is_read: true,
        message: "some message"
      })
      |> Todolist.RequestNotification.create_notification()

    notification
  end
end
