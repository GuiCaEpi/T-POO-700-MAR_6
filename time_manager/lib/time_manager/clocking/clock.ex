defmodule Todolist.Clocking.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :time, :utc_datetime
    field :user_id, :id
    field :status, :boolean, default: false
    field :team_id, :id


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:time, :user_id, :status, :team_id])
    |> validate_required([:time, :user_id, :status])
  end

  defimpl Jason.Encoder do
    def encode(%Todolist.Clocking.Clock{time: time, status: status, user_id: user_id, team_id: team_id}, opts) do
      Jason.Encode.map(%{
        user_id: user_id,
        time: time,
        status: status,
        team_id: team_id
      }, opts)
    end
  end

end
