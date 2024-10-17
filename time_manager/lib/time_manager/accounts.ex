defmodule Todolist.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Todolist.Repo

  alias Todolist.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """


  def list_users_by_email_and_username(email, username) do
    from(u in User, where: u.email == ^email and u.username == ^username)
    |> Repo.all()
  end

  def list_users_by_email(email) do
    from(u in User, where: u.email == ^email)
    |> Repo.all()
  end

  def list_users_by_username(username) do
    from(u in User, where: u.username == ^username)
    |> Repo.all()
  end

  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias Todolist.Accounts.Admin

  @doc """
  Returns the list of admins.

  ## Examples

      iex> list_admins()
      [%Admin{}, ...]

  """
  def list_admins do
    Repo.all(Admin)
  end

  @doc """
  Gets a single admin.

  Raises `Ecto.NoResultsError` if the Admin does not exist.

  ## Examples

      iex> get_admin!(123)
      %Admin{}

      iex> get_admin!(456)
      ** (Ecto.NoResultsError)

  """
  def get_admin!(id), do: Repo.get!(Admin, id)

  @doc """
  Creates a admin.

  ## Examples

      iex> create_admin(%{field: value})
      {:ok, %Admin{}}

      iex> create_admin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_admin(attrs \\ %{}) do
    %Admin{}
    |> Admin.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a admin.

  ## Examples

      iex> update_admin(admin, %{field: new_value})
      {:ok, %Admin{}}

      iex> update_admin(admin, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_admin(%Admin{} = admin, attrs) do
    admin
    |> Admin.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a admin.

  ## Examples

      iex> delete_admin(admin)
      {:ok, %Admin{}}

      iex> delete_admin(admin)
      {:error, %Ecto.Changeset{}}

  """
  def delete_admin(%Admin{} = admin) do
    Repo.delete(admin)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking admin changes.

  ## Examples

      iex> change_admin(admin)
      %Ecto.Changeset{data: %Admin{}}

  """
  def change_admin(%Admin{} = admin, attrs \\ %{}) do
    Admin.changeset(admin, attrs)
  end

  alias Todolist.Accounts.Manager

  @doc """
  Returns the list of managers.

  ## Examples

      iex> list_managers()
      [%Manager{}, ...]

  """
  def list_managers do
    Repo.all(Manager)
  end

  @doc """
  Gets a single manager.

  Raises `Ecto.NoResultsError` if the Manager does not exist.

  ## Examples

      iex> get_manager!(123)
      %Manager{}

      iex> get_manager!(456)
      ** (Ecto.NoResultsError)

  """
  def get_manager!(id), do: Repo.get!(Manager, id)

  @doc """
  Creates a manager.

  ## Examples

      iex> create_manager(%{field: value})
      {:ok, %Manager{}}

      iex> create_manager(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_manager(attrs \\ %{}) do
    %Manager{}
    |> Manager.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a manager.

  ## Examples

      iex> update_manager(manager, %{field: new_value})
      {:ok, %Manager{}}

      iex> update_manager(manager, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_manager(%Manager{} = manager, attrs) do
    manager
    |> Manager.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a manager.

  ## Examples

      iex> delete_manager(manager)
      {:ok, %Manager{}}

      iex> delete_manager(manager)
      {:error, %Ecto.Changeset{}}

  """
  def delete_manager(%Manager{} = manager) do
    Repo.delete(manager)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking manager changes.

  ## Examples

      iex> change_manager(manager)
      %Ecto.Changeset{data: %Manager{}}

  """
  def change_manager(%Manager{} = manager, attrs \\ %{}) do
    Manager.changeset(manager, attrs)
  end
end
