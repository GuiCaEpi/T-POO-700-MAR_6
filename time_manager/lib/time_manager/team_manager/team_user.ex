defmodule Todolist.TeamManager.TeamUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team_users" do

    belongs_to :user, Todolist.Accounts.User, foreign_key: :user_id
    belongs_to :team, Todolist.TeamManager.Team, foreign_key: :team_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team_user, attrs) do
    team_user
    |> cast(attrs, [:user_id, :team_id])
    |> validate_required([])
  end
end
