defmodule Todolist.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todolist.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        first_name: "some first_name",
        last_name: "some last_name"
      })
      |> Todolist.Accounts.create_user()

    user
  end

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        username: "some username"
      })
      |> Todolist.Accounts.create_user()

    user
  end

  @doc """
  Generate a unique admin email.
  """
  def unique_admin_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a admin.
  """
  def admin_fixture(attrs \\ %{}) do
    {:ok, admin} =
      attrs
      |> Enum.into(%{
        email: unique_admin_email(),
        name: "some name",
        password_hash: "some password_hash"
      })
      |> Todolist.Accounts.create_admin()

    admin
  end

  @doc """
  Generate a unique manager email.
  """
  def unique_manager_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a manager.
  """
  def manager_fixture(attrs \\ %{}) do
    {:ok, manager} =
      attrs
      |> Enum.into(%{
        email: unique_manager_email(),
        name: "some name",
        password_hash: "some password_hash"
      })
      |> Todolist.Accounts.create_manager()

    manager
  end
end
