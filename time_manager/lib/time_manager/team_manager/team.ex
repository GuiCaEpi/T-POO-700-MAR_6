defmodule Todolist.TeamManager.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :manager_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :manager_id])
    |> validate_required([:name, :manager_id])
  end

  defimpl Jason.Encoder do
    def encode(%Todolist.TeamManager.Team{name: name, manager_id: manager_id, id: id}, opts) do
      Jason.Encode.map(%{
        id: id,
        name: name,
        manager_id: manager_id
      }, opts)
    end
  end
end
