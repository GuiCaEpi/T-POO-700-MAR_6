defmodule TodolistWeb.ManagerJSON do
  alias Todolist.Accounts.Manager

  @doc """
  Renders a list of managers.
  """
  def index(%{managers: managers}) do
    %{data: for(manager <- managers, do: data(manager))}
  end

  @doc """
  Renders a single manager.
  """
  def show(%{manager: manager}) do
    %{data: data(manager)}
  end

  defp data(%Manager{} = manager) do
    %{
      id: manager.id,
      name: manager.name,
      email: manager.email,
      password_hash: manager.password_hash,
    }
  end
end
