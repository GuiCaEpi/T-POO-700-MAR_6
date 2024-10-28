defmodule Todolist.TeamManagerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todolist.TeamManager` context.
  """

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Todolist.TeamManager.create_team()

    team
  end

  @doc """
  Generate a team_user.
  """
  def team_user_fixture(attrs \\ %{}) do
    {:ok, team_user} =
      attrs
      |> Enum.into(%{

      })
      |> Todolist.TeamManager.create_team_user()

    team_user
  end
end
