defmodule Todolist.RequestNotification.CorrectionRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "correction_requests" do
    field :status, :string
    field :request_message, :string
    field :user_id, :id
    field :clock_id, :id
    field :manager_id, :id
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(correction_request, attrs) do
    correction_request
    |> cast(attrs, [:request_message, :status, :user_id, :clock_id, :manager_id])
    |> validate_required([:request_message, :status])
  end
end
