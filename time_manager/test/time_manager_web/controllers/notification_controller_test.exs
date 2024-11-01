defmodule TodolistWeb.NotificationControllerTest do
  use TodolistWeb.ConnCase

  import Todolist.RequestNotificationFixtures

  alias Todolist.RequestNotification.Notification

  @create_attrs %{
    message: "some message",
    is_read: true
  }
  @update_attrs %{
    message: "some updated message",
    is_read: false
  }
  @invalid_attrs %{message: nil, is_read: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all notifications", %{conn: conn} do
      conn = get(conn, ~p"/api/notifications")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create notification" do
    test "renders notification when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/notifications", notification: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/notifications/#{id}")

      assert %{
               "id" => ^id,
               "is_read" => true,
               "message" => "some message"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/notifications", notification: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update notification" do
    setup [:create_notification]

    test "renders notification when data is valid", %{conn: conn, notification: %Notification{id: id} = notification} do
      conn = put(conn, ~p"/api/notifications/#{notification}", notification: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/notifications/#{id}")

      assert %{
               "id" => ^id,
               "is_read" => false,
               "message" => "some updated message"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, notification: notification} do
      conn = put(conn, ~p"/api/notifications/#{notification}", notification: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete notification" do
    setup [:create_notification]

    test "deletes chosen notification", %{conn: conn, notification: notification} do
      conn = delete(conn, ~p"/api/notifications/#{notification}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/notifications/#{notification}")
      end
    end
  end

  defp create_notification(_) do
    notification = notification_fixture()
    %{notification: notification}
  end
end
