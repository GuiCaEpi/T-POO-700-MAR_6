defmodule TodolistWeb.TaskController do
  use TodolistWeb, :controller

  alias Todolist.Tasks

  # Supprimé l'alias non utilisé `Task`

  def index(conn, _params) do
    tasks = Tasks.list_tasks()
    render(conn, "index.json", tasks: tasks)
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    render(conn, "show.json", task: task)
  end

  def create(conn, %{"task" => task_params}) do
    case Tasks.create_task(task_params) do
      {:ok, task} ->
        conn
        |> put_status(:created)
        |> render("show.json", task: task)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(TodolistWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)

    case Tasks.update_task(task, task_params) do
      {:ok, task} ->
        render(conn, "show.json", task: task)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(TodolistWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    {:ok, _task} = Tasks.delete_task(task)

    send_resp(conn, :no_content, "")
  end

  # Fonction personnalisée pour obtenir les tâches d'un utilisateur spécifique
  def user_tasks(conn, %{"idUser" => user_id}) do
    tasks = Tasks.get_tasks_by_user(user_id)
    render(conn, "index.json", tasks: tasks)
  end
end
