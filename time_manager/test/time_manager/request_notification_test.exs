defmodule Todolist.RequestNotificationTest do
  use Todolist.DataCase

  alias Todolist.RequestNotification

  describe "correctionrequests" do
    alias Todolist.RequestNotification.CorrectionRequest

    import Todolist.RequestNotificationFixtures

    @invalid_attrs %{status: nil, request_message: nil}

    test "list_correctionrequests/0 returns all correctionrequests" do
      correction_request = correction_request_fixture()
      assert RequestNotification.list_correctionrequests() == [correction_request]
    end

    test "get_correction_request!/1 returns the correction_request with given id" do
      correction_request = correction_request_fixture()
      assert RequestNotification.get_correction_request!(correction_request.id) == correction_request
    end

    test "create_correction_request/1 with valid data creates a correction_request" do
      valid_attrs = %{status: "some status", request_message: "some request_message"}

      assert {:ok, %CorrectionRequest{} = correction_request} = RequestNotification.create_correction_request(valid_attrs)
      assert correction_request.status == "some status"
      assert correction_request.request_message == "some request_message"
    end

    test "create_correction_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RequestNotification.create_correction_request(@invalid_attrs)
    end

    test "update_correction_request/2 with valid data updates the correction_request" do
      correction_request = correction_request_fixture()
      update_attrs = %{status: "some updated status", request_message: "some updated request_message"}

      assert {:ok, %CorrectionRequest{} = correction_request} = RequestNotification.update_correction_request(correction_request, update_attrs)
      assert correction_request.status == "some updated status"
      assert correction_request.request_message == "some updated request_message"
    end

    test "update_correction_request/2 with invalid data returns error changeset" do
      correction_request = correction_request_fixture()
      assert {:error, %Ecto.Changeset{}} = RequestNotification.update_correction_request(correction_request, @invalid_attrs)
      assert correction_request == RequestNotification.get_correction_request!(correction_request.id)
    end

    test "delete_correction_request/1 deletes the correction_request" do
      correction_request = correction_request_fixture()
      assert {:ok, %CorrectionRequest{}} = RequestNotification.delete_correction_request(correction_request)
      assert_raise Ecto.NoResultsError, fn -> RequestNotification.get_correction_request!(correction_request.id) end
    end

    test "change_correction_request/1 returns a correction_request changeset" do
      correction_request = correction_request_fixture()
      assert %Ecto.Changeset{} = RequestNotification.change_correction_request(correction_request)
    end
  end

  describe "notifications" do
    alias Todolist.RequestNotification.Notification

    import Todolist.RequestNotificationFixtures

    @invalid_attrs %{message: nil, is_read: nil}

    test "list_notifications/0 returns all notifications" do
      notification = notification_fixture()
      assert RequestNotification.list_notifications() == [notification]
    end

    test "get_notification!/1 returns the notification with given id" do
      notification = notification_fixture()
      assert RequestNotification.get_notification!(notification.id) == notification
    end

    test "create_notification/1 with valid data creates a notification" do
      valid_attrs = %{message: "some message", is_read: true}

      assert {:ok, %Notification{} = notification} = RequestNotification.create_notification(valid_attrs)
      assert notification.message == "some message"
      assert notification.is_read == true
    end

    test "create_notification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RequestNotification.create_notification(@invalid_attrs)
    end

    test "update_notification/2 with valid data updates the notification" do
      notification = notification_fixture()
      update_attrs = %{message: "some updated message", is_read: false}

      assert {:ok, %Notification{} = notification} = RequestNotification.update_notification(notification, update_attrs)
      assert notification.message == "some updated message"
      assert notification.is_read == false
    end

    test "update_notification/2 with invalid data returns error changeset" do
      notification = notification_fixture()
      assert {:error, %Ecto.Changeset{}} = RequestNotification.update_notification(notification, @invalid_attrs)
      assert notification == RequestNotification.get_notification!(notification.id)
    end

    test "delete_notification/1 deletes the notification" do
      notification = notification_fixture()
      assert {:ok, %Notification{}} = RequestNotification.delete_notification(notification)
      assert_raise Ecto.NoResultsError, fn -> RequestNotification.get_notification!(notification.id) end
    end

    test "change_notification/1 returns a notification changeset" do
      notification = notification_fixture()
      assert %Ecto.Changeset{} = RequestNotification.change_notification(notification)
    end
  end
end
