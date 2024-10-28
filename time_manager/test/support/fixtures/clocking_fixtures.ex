defmodule Todolist.ClockingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todolist.Clocking` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        time: ~U[2024-10-07 12:27:00Z]
      })
      |> Todolist.Clocking.create_clock()

    clock
  end
end
