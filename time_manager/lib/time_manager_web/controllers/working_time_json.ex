defmodule TodolistWeb.WorkingTimeJSON do
  alias Todolist.Work.WorkingTime

  @doc """
  Renders a list of workingtimes.
  """
  def index(%{working_times: working_times}) do
    %{
      data: Enum.map(working_times, &render_working_time/1)
    }
  end

  defp render_working_time(%WorkingTime{id: id, start_time: start_time, end_time: end_time, user_id: user_id, team_id: team_id}) do
    %{
      id: id,
      start_time: start_time,
      end_time: end_time,
      user_id: user_id,
      team_id: team_id
    }
  end

  @doc """
  Renders a single working_time.
  """
  def show(%{working_time: working_time}) do
    %{data: data(working_time)}
  end

  defp data(%WorkingTime{} = working_time) do
    %{
      id: working_time.id,
      start_time: working_time.start_time,
      end_time: working_time.end_time,
      user_id: working_time.user_id,
      team_id: working_time.team_id
    }
  end
end
