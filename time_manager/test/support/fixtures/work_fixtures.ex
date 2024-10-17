defmodule Todolist.WorkFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todolist.Work` context.
  """

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end_time: ~U[2024-10-07 12:26:00Z],
        start_time: ~U[2024-10-07 12:26:00Z]
      })
      |> Todolist.Work.create_working_time()

    working_time
  end
end
