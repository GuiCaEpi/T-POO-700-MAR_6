defmodule TodolistWeb.Plugs.ManagerAuthorizationPlug do
  import Plug.Conn                                                               # Importe les fonctions du module Plug.Conn
  import Phoenix.Controller                                                      # Importe les fonctions de Phoenix.Controller
  alias Todolist.Accounts                                                        # Alias pour le module Todolist.Accounts
  alias Todolist.Clocking                                                        # Alias pour le module Todolist.Clocking
  alias Todolist.Work                                                            # Alias pour le module Todolist.Work
  require Logger                                                                 # Active les fonctions de log

  def init(default), do: default                                                 # Initialisation par défaut du plug

  def call(conn, _opts) do
    claims = Guardian.Plug.current_claims(conn)                                  # Récupère les claims du token JWT
    user_id = claims["sub"]                                                      # ID de l'utilisateur connecté
    privilege_level = claims["privilege_level"]                                  # Niveau de privilège de l'utilisateur

    manager_id = claims["sub"]                                                   # ID du manager
    manager_id_in_route = conn.params["managerID"]                               # ID du manager dans les paramètres de la route
    user_id_in_route = conn.params["userID"]                                     # ID de l'utilisateur dans les paramètres de la route
    team_id_in_route = conn.params["teamID"]                                     # ID de l'équipe dans les paramètres de la route
    team_id_in_request = get_team_id_from_params(conn.params)                    # ID de l'équipe dans les paramètres de la requête

    cond do
      privilege_level == 1 and not is_nil(team_id_in_route) ->
        if Accounts.is_valid_team_for_manager?(manager_id, team_id_in_route) do  # Vérifie si le manager peut accéder à l'équipe
          conn
        else
          conn
          |> put_status(:forbidden)
          |> json(%{error: "Accès refusé : vous n'êtes pas autorisé à gérer cette équipe car vous n'êtes pas le manager de l'équipe spécifiée."})  # Message d'erreur pour un accès interdit à une équipe non gérée par le manager
          |> halt()
        end

      privilege_level == 1 ->
        case conn.method do
          "DELETE" ->
            case conn.path_info do
              ["api", "protected", "manager", "clocks", _user_id, clock_id] ->
                Logger.info("Suppression de l'horloge détectée avec l'ID : #{clock_id}")    # Log pour suppression de l'horloge
                handle_clock_deletion_or_update(conn, clock_id, manager_id)

              ["api", "protected", "manager", "workingtime", _user_id, working_time_id] ->
                handle_working_time_deletion_or_update(conn, working_time_id, manager_id)  # Gestion de la suppression d'un working time

              _ ->
                conn
                |> put_status(:not_found)
                |> json(%{error: "Ressource non trouvée pour cette route. Assurez-vous que l'URL est correcte."})  # Message d'erreur pour ressource inexistante ou URL incorrecte
                |> halt()
            end

          "PUT" ->
            case conn.path_info do
              ["api", "protected", "manager", "clocks", _user_id, clock_id] ->
                Logger.info("Mise à jour de l'horloge détectée avec l'ID : #{clock_id}")   # Log pour mise à jour de l'horloge
                handle_clock_deletion_or_update(conn, clock_id, manager_id)

              ["api", "protected", "manager", "workingtime", _user_id, working_time_id] ->
                handle_working_time_deletion_or_update(conn, working_time_id, manager_id)  # Gestion de la mise à jour d'un working time

              _ ->
                conn
                |> put_status(:not_found)
                |> json(%{error: "Ressource non trouvée pour cette route. Assurez-vous que l'URL est correcte."})  # Message d'erreur pour ressource inexistante ou URL incorrecte
                |> halt()
            end

          _ ->
            if user_id_in_route do
              user_belongs_to_team = Accounts.get_team_for_manager_and_user(manager_id, user_id_in_route)

              if user_belongs_to_team do
                if team_id_in_request do
                  if Accounts.is_valid_team_for_manager?(manager_id, team_id_in_request) do
                    conn
                  else
                    conn
                    |> put_status(:forbidden)
                    |> json(%{error: "Accès refusé : vous ne pouvez pas créer une horloge pour cet utilisateur car l'équipe ne fait pas partie de vos équipes gérées."})  # Message d'erreur pour création d'horloge interdite pour une équipe non gérée
                    |> halt()
                  end
                else
                  conn
                end
              else
                conn
                |> put_status(:forbidden)
                |> json(%{error: "Accès refusé : vous n'êtes pas autorisé à gérer les ressources de cet utilisateur car il n'est pas dans votre équipe."})  # Message d'erreur pour accès à une ressource interdite pour un utilisateur non assigné
                |> halt()
              end
            else
              if manager_id_in_route == manager_id do
                conn
              else
                conn
                |> put_status(:forbidden)
                |> json(%{error: "Accès refusé : le manager ID fourni ne correspond pas à votre ID. Vous ne pouvez accéder qu'à vos propres ressources."})  # Message d'erreur pour un accès de ressource à un manager ID différent
                |> halt()
              end
            end
        end

      true ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Accès refusé à cette ressource. Vérifiez votre niveau de privilège."})  # Message d'erreur pour accès interdit en raison de privilèges insuffisants
        |> halt()
    end
  end

  defp get_team_id_from_params(params) do
    team_id_from_clock = Map.get(params["clock"] || %{}, "team_id")                                            # Récupère l'ID de l'équipe depuis le paramètre clock
    team_id_from_workingtimes = Map.get(params["workingtimes"] || %{}, "team_id")                              # Récupère l'ID de l'équipe depuis le paramètre workingtimes

    team_id_from_clock || team_id_from_workingtimes                                                            # Retourne l'ID de l'équipe si disponible
  end

  defp valid_team_for_manager?(team_id, manager_id) do
    Accounts.is_valid_team_for_manager?(manager_id, team_id)                                                   # Vérifie si l'équipe est valide pour le manager
  end

  defp handle_clock_deletion_or_update(conn, clock_id, manager_id) do
    case Clocking.get_clock!(clock_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Horloge introuvable : l'ID fourni est incorrect ou l'horloge n'existe plus."})      # Message d'erreur pour horloge introuvable avec ID incorrect
        |> halt()

      clock ->
        if valid_team_for_manager?(clock.team_id, manager_id) do
          conn
        else
          conn
          |> put_status(:forbidden)
          |> json(%{error: "Accès refusé : vous n'êtes pas autorisé à supprimer ou modifier cette horloge car l'équipe n'est pas gérée par vous."})  # Message d'erreur pour suppression/modification d'horloge interdite pour une équipe non gérée
          |> halt()
        end
    end
  end

  defp handle_working_time_deletion_or_update(conn, working_time_id, manager_id) do
    case Work.get_working_time!(working_time_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Temps de travail introuvable : l'ID fourni est incorrect ou le temps de travail n'existe plus."})  # Message d'erreur pour temps de travail introuvable avec ID incorrect
        |> halt()

      working_time ->
        if valid_team_for_manager?(working_time.team_id, manager_id) do
          conn
        else
          conn
          |> put_status(:forbidden)
          |> json(%{error: "Accès refusé : vous n'êtes pas autorisé à supprimer ou modifier ce temps de travail car l'équipe n'est pas sous votre gestion."})  # Message d'erreur pour suppression/modification interdite de temps de travail pour une équipe non gérée
          |> halt()
        end
    end
  end
end
