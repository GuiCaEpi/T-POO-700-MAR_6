defmodule TodolistWeb.Plugs.UserAuthorizationPlug do
  import Plug.Conn                                                         # Importe les fonctions du module Plug.Conn
  import Phoenix.Controller                                                # Importe les fonctions de Phoenix.Controller
  alias Todolist.Accounts                                                  # Alias pour le module Todolist.Accounts

  def init(default), do: default                                           # Initialisation par défaut du plug

  def call(conn, _opts) do
    claims = Guardian.Plug.current_claims(conn)                            # Récupère les claims du token JWT
    user_id = claims["sub"]                                                # ID de l'utilisateur connecté
    privilege_level = claims["privilege_level"]                            # Niveau de privilège de l'utilisateur

    IO.inspect(claims, label: "Guardian claims")                           # Debug: Affiche les claims
    IO.inspect(user_id, label: "User ID from claims")                      # Debug: Affiche l'ID utilisateur
    IO.inspect(privilege_level, label: "Privilege level from claims")      # Debug: Affiche le niveau de privilège

    # Si l'utilisateur est un simple utilisateur (0 = user)
    cond do
      privilege_level == 0 ->
        IO.puts("User is a simple user")                                   # Debug: Utilisateur simple
        check_user_access(conn, user_id, privilege_level)                  # Vérifie l'accès pour les utilisateurs

      # Si c'est un manager ou un admin, on permet l'accès (par exemple, niveau 1 ou 2)
      privilege_level > 0 ->
        IO.puts("User is a manager or admin")                              # Debug: Utilisateur manager/admin
        conn

      # Si le niveau de privilège est incorrect, accès refusé
      true ->
        IO.puts("Privilege level invalid")                                 # Debug: Niveau de privilège incorrect
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Unauthorized access."})
        |> halt()
    end
  end

  defp check_user_access(conn, user_id, _privilege_level) do
    user_id_in_route = conn.params["userID"]                               # Récupère l'ID utilisateur depuis les params de route
    team_id_in_body = conn.body_params["clock"]["team_id"]                 # Récupère le team_id depuis le body

    IO.inspect(conn.path_info, label: "Request path info")                 # Debug: Affiche le chemin de la requête
    IO.inspect(conn.method, label: "Request method")                       # Debug: Affiche la méthode de la requête
    IO.inspect(user_id_in_route, label: "User ID in route")                # Debug: Affiche l'ID utilisateur dans la route
    IO.inspect(team_id_in_body, label: "Team ID from body")                # Debug: Affiche le team_id depuis le body

    cond do
      # L'utilisateur peut accéder à ses propres working times
      conn.path_info == ["api", "protected", "user", "workingtime", user_id_in_route] ->
        if user_id == user_id_in_route do
          IO.puts("Access to working times granted")                       # Debug: Accès aux horaires de travail accordé
          conn
        else
          IO.puts("Access to working times denied")                        # Debug: Accès aux horaires de travail refusé
          conn
          |> put_status(:forbidden)
          |> json(%{error: "Vous ne pouvez pas consulter les working times d'un autre utilisateur."})
          |> halt()
        end

      # L'utilisateur peut consulter ses propres équipes
      conn.path_info == ["api", "protected", "user", "teams", user_id_in_route] ->
        if user_id == user_id_in_route do
          IO.puts("Access to user's teams granted")                       # Debug: Accès aux équipes utilisateur accordé
          conn
        else
          IO.puts("Access to user's teams denied")                        # Debug: Accès aux équipes utilisateur refusé
          conn
          |> put_status(:forbidden)
          |> json(%{error: "Vous ne pouvez pas consulter les équipes d'un autre utilisateur."})
          |> halt()
        end

      # L'utilisateur peut clocker uniquement pour une team dont il est membre
      conn.method == "POST" and conn.path_info == ["api", "protected", "user", "clocks", user_id_in_route] ->
        if user_id == user_id_in_route and Todolist.Accounts.is_user_in_team?(user_id, team_id_in_body) do
          conn
        else
          conn
          |> put_status(:forbidden)
          |> json(%{error: "Vous ne faites pas partie de cette équipe."})
          |> halt()
        end

      # L'utilisateur peut voir ses managers
      conn.path_info == ["api", "protected", "user", "managers", user_id_in_route] ->
        if user_id == user_id_in_route do
          IO.puts("Access to managers granted")                          # Debug: Accès aux managers accordé
          conn
        else
          IO.puts("Access to managers denied")                           # Debug: Accès aux managers refusé
          conn
          |> put_status(:forbidden)
          |> json(%{error: "Vous ne pouvez pas voir les managers d'un autre utilisateur."})
          |> halt()
        end

      # L'utilisateur peut envoyer une correction request pour une team où il a clocké
      conn.method == "POST" and conn.path_info == ["api", "protected", "user", "correctionrequests", user_id_in_route] ->
        if user_id == user_id_in_route and Accounts.is_user_in_team?(user_id, team_id_in_body) do
          IO.puts("Correction request authorized")                       # Debug: Demande de correction autorisée
          conn
        else
          IO.puts("Correction request forbidden")                        # Debug: Demande de correction refusée
          conn
          |> put_status(:forbidden)
          |> json(%{error: "You cannot request a correction for this team."})
          |> halt()
        end

      # Sinon, accès interdit pour toutes les autres ressources
      true ->
        IO.puts("Unauthorized access to other resources")                # Debug: Accès non autorisé aux autres ressources
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Unauthorized access."})
        |> halt()
    end
  end
end
