defmodule TodolistWeb.CorrectionRequestControllerTest do
  use TodolistWeb.ConnCase

  import Todolist.RequestNotificationFixtures

  alias Todolist.RequestNotification.CorrectionRequest

  @create_attrs %{
    status: "some status",
    request_message: "some request_message"
  }
  @update_attrs %{
    status: "some updated status",
    request_message: "some updated request_message"
  }
  @invalid_attrs %{status: nil, request_message: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all correctionrequests", %{conn: conn} do
      conn = get(conn, ~p"/api/correctionrequests")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create correction_request" do
    test "renders correction_request when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/correctionrequests", correction_request: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/correctionrequests/#{id}")

      assert %{
               "id" => ^id,
               "request_message" => "some request_message",
               "status" => "some status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/correctionrequests", correction_request: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update correction_request" do
    setup [:create_correction_request]

    test "renders correction_request when data is valid", %{conn: conn, correction_request: %CorrectionRequest{id: id} = correction_request} do
      conn = put(conn, ~p"/api/correctionrequests/#{correction_request}", correction_request: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/correctionrequests/#{id}")

      assert %{
               "id" => ^id,
               "request_message" => "some updated request_message",
               "status" => "some updated status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, correction_request: correction_request} do
      conn = put(conn, ~p"/api/correctionrequests/#{correction_request}", correction_request: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete correction_request" do
    setup [:create_correction_request]

    test "deletes chosen correction_request", %{conn: conn, correction_request: correction_request} do
      conn = delete(conn, ~p"/api/correctionrequests/#{correction_request}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/correctionrequests/#{correction_request}")
      end
    end
  end

  defp create_correction_request(_) do
    correction_request = correction_request_fixture()
    %{correction_request: correction_request}
  end
end
