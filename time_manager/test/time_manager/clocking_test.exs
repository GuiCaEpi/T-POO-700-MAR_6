defmodule Todolist.ClockingTest do
  use Todolist.DataCase

  alias Todolist.Clocking

  describe "clocks" do
    alias Todolist.Clocking.Clock

    import Todolist.ClockingFixtures

    @invalid_attrs %{time: nil}

    test "list_clocks/0 returns all clocks" do
      clock = clock_fixture()
      assert Clocking.list_clocks() == [clock]
    end

    test "get_clock!/1 returns the clock with given id" do
      clock = clock_fixture()
      assert Clocking.get_clock!(clock.id) == clock
    end

    test "create_clock/1 with valid data creates a clock" do
      valid_attrs = %{time: ~U[2024-10-07 12:27:00Z]}

      assert {:ok, %Clock{} = clock} = Clocking.create_clock(valid_attrs)
      assert clock.time == ~U[2024-10-07 12:27:00Z]
    end

    test "create_clock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clocking.create_clock(@invalid_attrs)
    end

    test "update_clock/2 with valid data updates the clock" do
      clock = clock_fixture()
      update_attrs = %{time: ~U[2024-10-08 12:27:00Z]}

      assert {:ok, %Clock{} = clock} = Clocking.update_clock(clock, update_attrs)
      assert clock.time == ~U[2024-10-08 12:27:00Z]
    end

    test "update_clock/2 with invalid data returns error changeset" do
      clock = clock_fixture()
      assert {:error, %Ecto.Changeset{}} = Clocking.update_clock(clock, @invalid_attrs)
      assert clock == Clocking.get_clock!(clock.id)
    end

    test "delete_clock/1 deletes the clock" do
      clock = clock_fixture()
      assert {:ok, %Clock{}} = Clocking.delete_clock(clock)
      assert_raise Ecto.NoResultsError, fn -> Clocking.get_clock!(clock.id) end
    end

    test "change_clock/1 returns a clock changeset" do
      clock = clock_fixture()
      assert %Ecto.Changeset{} = Clocking.change_clock(clock)
    end
  end
end
