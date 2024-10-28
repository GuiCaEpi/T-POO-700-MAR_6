defmodule Todolist.Tasks do
  import Ecto.Query, warn: false
  alias Todolist.Repo
  alias Todolist.Tasks.Task

  def list_tasks do
    Repo.all(Task)
  end

  def get_task!(id), do: Repo.get!(Task, id)

  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  # Fonction pour obtenir les tâches d'un utilisateur spécifique
  def get_tasks_by_user(user_id) do
    from(t in Task, where: t.user_id == ^user_id)
    |> Repo.all()
  end
end
