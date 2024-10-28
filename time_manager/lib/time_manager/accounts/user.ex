defmodule Todolist.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :password_hash, :string
    field :privilege_level, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password_hash, :privilege_level])
    |> validate_required([:email, :password_hash])
    |> validate_length(:password_hash, min: 6)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true , changes: %{password_hash: password_hash}} = changeset) do
    change(changeset, password_hash: Bcrypt.hash_pwd_salt(password_hash))
  end

  defp put_password_hash(changeset) do changeset
  end

  defimpl Jason.Encoder do
    def encode(%Todolist.Accounts.User{username: username, email: email, password_hash: password_hash, privilege_level: privilege_level, id: id}, opts) do
      Jason.Encode.map(%{
        id: id,
        username: username,
        email: email,
        password_hash: password_hash,
        privilege_level: privilege_level
      }, opts)
    end
  end
end
