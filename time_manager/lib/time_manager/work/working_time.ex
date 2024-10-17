defmodule Todolist.Work.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtimes" do
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :user_id, :id
    field :team_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start_time, :end_time, :user_id, :team_id])
    |> validate_required([:start_time, :end_time, :user_id])
    |> validate_end_after_start()

  end


  defimpl Jason.Encoder do
    def encode(%Todolist.Work.WorkingTime{start_time: start_time, end_time: end_time, user_id: user_id, team_id: team_id}, opts) do
      Jason.Encode.map(%{
        user_id: user_id,
        start_time: start_time,
        end_time: end_time,
        team_id: team_id
      }, opts)
      end
  end

  defp validate_end_after_start(changeset) do
    start_time = get_field(changeset, :start_time)
    end_time = get_field(changeset, :end_time)

    if start_time && end_time && DateTime.compare(start_time, end_time) != :lt do
      add_error(changeset, :end_time, "must be after start time")
    else
      changeset
    end
  end
end
