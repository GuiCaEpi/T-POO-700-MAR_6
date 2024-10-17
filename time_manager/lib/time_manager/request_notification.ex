defmodule Todolist.RequestNotification do
  @moduledoc """
  The RequestNotification context.
  """

  import Ecto.Query, warn: false
  alias Todolist.Repo

  alias Todolist.RequestNotification.CorrectionRequest

  @doc """
  Returns the list of correctionrequests.

  ## Examples

      iex> list_correctionrequests()
      [%CorrectionRequest{}, ...]

  """

  def get_request_by_user_and_id(user_id, id) do
    from(r in CorrectionRequest, where: r.user_id == ^user_id and r.id == ^id)
    |> Repo.one()
  end

  def get_request_by_manager_and_id(manager_id, id) do
    from(r in CorrectionRequest, where: r.manager_id == ^manager_id and r.id == ^id)
    |> Repo.one()
  end

  def get_requests_by_user_id(user_id) do
    from(r in CorrectionRequest,
      where: r.user_id == ^user_id)
    |> Repo.all()
  end

  def get_requests_by_manager_id(manager_id) do
    from(r in CorrectionRequest,
      where: r.manager_id == ^manager_id)
    |> Repo.all()
  end

  def get_correction_request_by_manager_and_id(manager_id, id) do
    from(r in CorrectionRequest, where: r.manager_id == ^manager_id and r.id == ^id)
    |> Repo.one()
  end

  def list_correctionrequests do
    Repo.all(CorrectionRequest)
  end

  @doc """
  Gets a single correction_request.

  Raises `Ecto.NoResultsError` if the Correction request does not exist.

  ## Examples

      iex> get_correction_request!(123)
      %CorrectionRequest{}

      iex> get_correction_request!(456)
      ** (Ecto.NoResultsError)

  """
  def get_correction_request!(id), do: Repo.get!(CorrectionRequest, id)

  @doc """
  Creates a correction_request.

  ## Examples

      iex> create_correction_request(%{field: value})
      {:ok, %CorrectionRequest{}}

      iex> create_correction_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_correction_request(attrs \\ %{}) do
    %CorrectionRequest{}
    |> CorrectionRequest.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a correction_request.

  ## Examples

      iex> update_correction_request(correction_request, %{field: new_value})
      {:ok, %CorrectionRequest{}}

      iex> update_correction_request(correction_request, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_correction_request(%CorrectionRequest{} = correction_request, attrs) do
    correction_request
    |> CorrectionRequest.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a correction_request.

  ## Examples

      iex> delete_correction_request(correction_request)
      {:ok, %CorrectionRequest{}}

      iex> delete_correction_request(correction_request)
      {:error, %Ecto.Changeset{}}

  """
  def delete_correction_request(%CorrectionRequest{} = correction_request) do
    Repo.delete(correction_request)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking correction_request changes.

  ## Examples

      iex> change_correction_request(correction_request)
      %Ecto.Changeset{data: %CorrectionRequest{}}

  """
  def change_correction_request(%CorrectionRequest{} = correction_request, attrs \\ %{}) do
    CorrectionRequest.changeset(correction_request, attrs)
  end

  alias Todolist.RequestNotification.Notification

  @doc """
  Returns the list of notifications.

  ## Examples

      iex> list_notifications()
      [%Notification{}, ...]

  """
  def list_notifications do
    Repo.all(Notification)
  end

  @doc """
  Gets a single notification.

  Raises `Ecto.NoResultsError` if the Notification does not exist.

  ## Examples

      iex> get_notification!(123)
      %Notification{}

      iex> get_notification!(456)
      ** (Ecto.NoResultsError)

  """
  def get_notification!(id), do: Repo.get!(Notification, id)

  @doc """
  Creates a notification.

  ## Examples

      iex> create_notification(%{field: value})
      {:ok, %Notification{}}

      iex> create_notification(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_notification(attrs \\ %{}) do
    %Notification{}
    |> Notification.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a notification.

  ## Examples

      iex> update_notification(notification, %{field: new_value})
      {:ok, %Notification{}}

      iex> update_notification(notification, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_notification(%Notification{} = notification, attrs) do
    notification
    |> Notification.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a notification.

  ## Examples

      iex> delete_notification(notification)
      {:ok, %Notification{}}

      iex> delete_notification(notification)
      {:error, %Ecto.Changeset{}}

  """
  def delete_notification(%Notification{} = notification) do
    Repo.delete(notification)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking notification changes.

  ## Examples

      iex> change_notification(notification)
      %Ecto.Changeset{data: %Notification{}}

  """
  def change_notification(%Notification{} = notification, attrs \\ %{}) do
    Notification.changeset(notification, attrs)
  end
end
