defmodule TodolistWeb.ManagerControllerTest do
  use TodolistWeb.ConnCase

  import Todolist.AccountsFixtures

  alias Todolist.Accounts.Manager

  @create_attrs %{
    name: "some name",
    email: "some email",
    password_hash: "some password_hash"
  }
  @update_attrs %{
    name: "some updated name",
    email: "some updated email",
    password_hash: "some updated password_hash"
  }
  @invalid_attrs %{name: nil, email: nil, password_hash: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all managers", %{conn: conn} do
      conn = get(conn, ~p"/api/managers")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create manager" do
    test "renders manager when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/managers", manager: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/managers/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some email",
               "name" => "some name",
               "password_hash" => "some password_hash"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/managers", manager: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update manager" do
    setup [:create_manager]

    test "renders manager when data is valid", %{conn: conn, manager: %Manager{id: id} = manager} do
      conn = put(conn, ~p"/api/managers/#{manager}", manager: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/managers/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some updated email",
               "name" => "some updated name",
               "password_hash" => "some updated password_hash"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, manager: manager} do
      conn = put(conn, ~p"/api/managers/#{manager}", manager: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete manager" do
    setup [:create_manager]

    test "deletes chosen manager", %{conn: conn, manager: manager} do
      conn = delete(conn, ~p"/api/managers/#{manager}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/managers/#{manager}")
      end
    end
  end

  defp create_manager(_) do
    manager = manager_fixture()
    %{manager: manager}
  end
end
