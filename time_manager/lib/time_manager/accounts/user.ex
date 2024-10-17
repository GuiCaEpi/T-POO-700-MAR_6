defmodule Todolist.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string
    field :privilege_level, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password, :privilege_level])
    |> validate_required([:email, :username])
  end

  defimpl Jason.Encoder do
    def encode(%Todolist.Accounts.User{username: username, email: email, password: password, privilege_level: privilege_level, id: id}, opts) do
      Jason.Encode.map(%{
        id: id,
        username: username,
        email: email,
        password: password,
        privilege_level: privilege_level
      }, opts)
    end
  end
end
