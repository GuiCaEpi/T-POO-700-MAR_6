defmodule TodolistWeb.TeamUserJSON do
  alias Todolist.TeamManager.TeamUser

  @doc """
  Renders a list of teamusers.
  """
  def index(%{teamusers: teamusers}) do
    %{data: for(team_user <- teamusers, do: data(team_user))}
  end

  @doc """
  Renders a single team_user.
  """
  def show(%{team_user: team_user}) do
    %{data: data(team_user)}
  end

  defp data(%TeamUser{} = team_user) do
    %{
      id: team_user.id,
      user_id: team_user.user_id,
      team_id: team_user.team_id
    }
  end
end
