defmodule TodolistWeb.CorrectionRequestJSON do
  alias Todolist.RequestNotification.CorrectionRequest

  @doc """
  Renders a list of correctionrequests.
  """
  def index(%{correction_requests: correction_requests}) do
    %{data: for(correction_request <- correction_requests, do: data(correction_request))}
  end

  @doc """
  Renders a single correction_request.
  """
  def show(%{correction_request: correction_request}) do
    %{data: data(correction_request)}
  end

  defp data(%CorrectionRequest{} = correction_request) do
    %{
      id: correction_request.id,
      request_message: correction_request.request_message,
      status: correction_request.status,
      user_id: correction_request.user_id,
      clock_id: correction_request.clock_id,
      manager_id: correction_request.manager_id
    }
  end
end
