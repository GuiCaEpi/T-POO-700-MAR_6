defmodule TodolistWeb.Router do
  use TodolistWeb, :router

  pipeline :api do
    plug :accepts, ["json"]                                           # Accepte uniquement les requêtes JSON
    plug CORSPlug, origin: ["http://localhost:5173"]                  # Autorise les requêtes CORS depuis localhost:5173
  end

  pipeline :authenticated do
    plug Guardian.Plug.Pipeline,                                      # Initialise le pipeline Guardian pour l'authentification
      module: TodolistWeb.Auth.Guardian,
      error_handler: TodolistWeb.Auth.ErrorHandler

    plug Guardian.Plug.VerifyHeader                                   # Vérifie le token dans l'en-tête
    plug Guardian.Plug.LoadResource                                   # Charge la ressource utilisateur associée
    plug TodolistWeb.Plugs.CSRFPlug                                   # Protection contre les attaques CSRF
  end

  pipeline :admin_authorized do
    plug TodolistWeb.Plugs.RoleAuthorization, 2                       # Admin privilege level
  end

  pipeline :manager_authorized do
    plug TodolistWeb.Plugs.ManagerAuthorizationPlug                   # Privilège manager
  end

  pipeline :user_authorized do
    plug TodolistWeb.Plugs.UserAuthorizationPlug                      # Privilège utilisateur
  end

  # Routes de base de l'API
  scope "/api", TodolistWeb do
    pipe_through :api

    # - AUTHENTICATION -
    post "/sign_up",AuthController,:sign_up                           # Inscription d'un nouvel utilisateur
    post "/sign_in",AuthController,:sign_in                           # Connexion d'un utilisateur
    delete "/sign_out",AuthController,:sign_out                       # Déconnexion d'un utilisateur
  end

  # SCOPE - ADMIN -
  scope "/api/protected/admin", TodolistWeb do
    pipe_through [:api, :authenticated, :admin_authorized]

    # - USERS -
    resources "/users",UserController,except: [:new,:edit]            # CRUD pour les utilisateurs (sauf :new et :edit)

    # - TEAMS -
    resources "/teams",TeamController,except: [:new,:edit]            # CRUD pour les équipes (sauf :new et :edit)

    # - WORKINGTIMES -
    get "/workingtime/:userID",WorkingTimeController,:index           # Récupérer tous les horaires de travail d'un utilisateur
    get "/workingtime/:userID/:id",WorkingTimeController,:show        # Afficher un horaire de travail spécifique d'un utilisateur
    post "/workingtime/:userID",WorkingTimeController,:create         # Créer un nouvel horaire de travail pour un utilisateur
    put "/workingtime/:userID/:id",WorkingTimeController,:update      # Mettre à jour un horaire de travail existant pour un utilisateur
    delete "/workingtime/:userID/:id",WorkingTimeController,:delete   # Supprimer un horaire de travail spécifique d'un utilisateur

    # - RELATION TEAM / USER -
    get "team/:teamID/users",TeamUserController,:index_users          # Récupérer tous les utilisateurs d'une équipe
    get "team/:userID/teams",TeamUserController,:index_teams          # Récupérer toutes les équipes d'un utilisateur
    resources "/team_users",TeamUserController,except: [:new,:edit]   # CRUD pour relations équipe/utilisateur (sauf :new et :edit)

    # - CLOCKS -
    # resources "/clocks",ClockController,except: [:new,:edit]         # Gestion des points d'horloge pour tous les utilisateurs
    get "/clocks/:userID",ClockController,:index                      # Récupérer tous les points d'horloge pour un utilisateur
    get "/clocks/:userID/:id",ClockController,:show                   # Afficher un point d'horloge spécifique pour un utilisateur
    put "/clocks/:userID/:id",ClockController,:update                 # Mettre à jour un point d'horloge spécifique pour un utilisateur
    delete "/clocks/:userID/:id",ClockController,:delete              # Supprimer un point d'horloge spécifique d'un utilisateur
    post "/clocks/:userID",ClockController,:create                    # Créer un nouveau point d'horloge pour un utilisateur

    # - CORRECTION REQUESTS -
    resources "/correctionrequests",CorrectionRequestController,except: [:new,:edit,:create] # Gestion des demandes de correction
  end

  # SCOPE - MANAGER -
  scope "api/protected/manager", TodolistWeb do
    pipe_through [:api,:authenticated,:manager_authorized]

    # Teams
    get "/team/:teamID/users",TeamUserController,:index_users         # Récupérer tous les utilisateurs d'une équipe
    get "/team/:managerID",TeamController,:index_teams_for_manager    # Récupérer toutes les équipes d'un manager spécifique

    # Working times
    get "/workingtime/:userID",WorkingTimeController,:index           # Récupérer tous les horaires de travail d'un utilisateur
    get "/workingtime/:userID/:id",WorkingTimeController,:show        # Afficher un horaire de travail spécifique d'un utilisateur
    post "/workingtime/:userID",WorkingTimeController,:create         # Créer un nouvel horaire de travail pour un utilisateur
    put "/workingtime/:userID/:id",WorkingTimeController,:update      # Mettre à jour un horaire de travail existant pour un utilisateur
    delete "/workingtime/:userID/:id",WorkingTimeController,:delete   # Supprimer un horaire de travail spécifique d'un utilisateur

    # CLOCKS
    get "/clocks/:userID",ClockController,:index                      # Récupérer tous les points d'horloge pour un utilisateur
    get "/clocks/:userID/:id",ClockController,:show                   # Afficher un point d'horloge spécifique pour un utilisateur

    # Correction requests
    get "/correctionrequests/:managerID",CorrectionRequestController,:index_manager     # Récupérer toutes les demandes de correction d'un manager
    get "/correctionrequests/:managerID/:id",CorrectionRequestController,:show_manager  # Afficher une demande de correction spécifique d'un manager
    put "/correctionrequests/:managerID/:id",CorrectionRequestController,:update_manager # Mettre à jour une demande de correction d'un manager
  end

  # Routes protégées pour les utilisateurs
  scope "/api/protected/user", TodolistWeb do
    pipe_through [:api,:authenticated,:user_authorized]

    # Working times
    get "/workingtime/:userID",WorkingTimeController,:index           # Récupérer tous les horaires de travail d'un utilisateur
    get "/workingtime/:userID/:id",WorkingTimeController,:show        # Afficher un horaire de travail spécifique d'un utilisateur

    # Clocks
    post "/clocks/:userID",ClockController,:create                    # Créer un nouveau point d'horloge pour un utilisateur

    # Teams
    get "/teams/:userID",TeamController,:index_teams_for_user         # Récupérer toutes les équipes pour un utilisateur

    # Route pour récupérer les managers des équipes d'un utilisateur
    get "/managers/:userID",TeamUserController,:list_user_managers    # Récupérer les managers pour les équipes de l'utilisateur

    # Correction requests
    post "/correctionrequests/:userID",CorrectionRequestController,:create   # Créer une demande de correction pour un utilisateur
  end

  # Routes de développement (LiveDashboard)
  if Application.compile_env(:time_manager,:dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session,:protect_from_forgery]

      live_dashboard "/dashboard",metrics: TodolistWeb.Telemetry       # Dashboard en temps réel pour les métriques
      forward "/mailbox",Plug.Swoosh.MailboxPreview                    # Affiche la boîte aux lettres en développement
    end
  end
end
