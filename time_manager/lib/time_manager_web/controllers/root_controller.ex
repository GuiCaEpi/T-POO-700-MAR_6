defmodule TodolistWeb.RootController do
  use TodolistWeb, :controller

  def index(conn, _params) do
    json(conn, %{message: "Welcome to the Time Manager API"})
  end
end
