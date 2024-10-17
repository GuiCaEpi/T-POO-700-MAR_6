defmodule Todolist.Accounts.Manager do
  use Ecto.Schema
  import Ecto.Changeset

  schema "managers" do
    field :name, :string
    field :email, :string
    field :password_hash, :string

    # belongs_to :admin, Todolist.Accounts.Admin
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(manager, attrs) do
    manager
    |> cast(attrs, [:name, :email, :password_hash])
    |> validate_required([:name, :email, :password_hash])
    |> unique_constraint(:email)
  end
end
