defmodule Todolist.RequestNotification.Notification do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notifications" do
    field :message, :string
    field :is_read, :boolean, default: false
    field :user_id, :id
    field :manager_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:message, :is_read])
    |> validate_required([:message, :is_read])
  end
end
