defmodule TodolistWeb.TeamJSON do
  alias Todolist.TeamManager.Team

  @doc """
  Renders a list of teams.
  """
  def index(%{teams: teams}) do
    %{data: for(team <- teams, do: data(team))}
  end

  @doc """
  Renders a single team.
  """
  def show(%{team: team}) do
    %{data: data(team)}
  end

  defp data(%{id: id, name: name, manager_id: manager_id}) do
    %{
      id: id,
      name: name,
      manager_id: manager_id
    }
  end
end
