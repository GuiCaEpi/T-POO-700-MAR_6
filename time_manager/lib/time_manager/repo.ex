defmodule Todolist.Repo do
  use Ecto.Repo,
    otp_app: :time_manager,
    adapter: Ecto.Adapters.Postgres
end
