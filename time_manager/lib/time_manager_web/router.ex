defmodule TodolistWeb.Router do
  use TodolistWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug, origin: ["http://localhost:5173"]
  end

  scope "/api", TodolistWeb do
    pipe_through :api

    # ADMINS : [:index, :show, :create, :update, :delete]
    resources "/admins", AdminController, except: [:new, :edit]

    # MANAGERS : [:index, :show, :create, :update, :delete]
    resources "/managers", ManagerController, except: [:new, :edit]

    # USERS : [:index, :show, :create, :update, :delete]
    resources "/users", UserController, except: [:new, :edit]

    # TEAMS :
    # resources "/teams", TeamController, except: [:new, :edit]
    get "/users/:userID/teams", TeamController, :index_teams_for_user



    # TEAMUSER : [:index, :show, :create, :update, :delete]
    resources "/teamuser", TeamUserController, except: [:new, :edit]

    # WORKINGTIMES :

    # create a workingtime for a specific user
    post "/workingtime/:userID", WorkingTimeController, :create

    # show the workingtime of a specific user with params
    # ex: "http://localhost:4000/api/workingtime/21?start=2024-10-11T19:00:47Z&end=2024-10-11T19:00:47Z"
    # start = start_time & end = end_time
    get "/workingtime/:userID", WorkingTimeController, :index

    # show a workingtime for a specific user with its id
    get "/workingtime/:userID/:id", WorkingTimeController, :show

    # update a working time with its id
    put "/workingtime/:id", WorkingTimeController, :update

    # delete a workingtime with its id
    delete "/workingtime/:id", WorkingTimeController, :delete

    # CLOCKS :

    # create a clock for a specific user
    post "/clocks/:userID", ClockController, :create

    # get all clocks for a specific user
    get "/clocks/:userID", ClockController, :index

    # CORRECTIONREQUESTS :
    # resources "/correctionrequests", CorrectionRequestController, except: [:new, :edit]

    # User Routes
    # for the user to create a new request
    post "/correctionrequests/user/:userID", CorrectionRequestController, :create
    # for the user to see one of his requests
    get "/correctionrequests/user/:userID/:id", CorrectionRequestController, :show_user
    # for the user to see all of his requests
    get "/correctionrequests/user/:userID", CorrectionRequestController, :index_user

  # Manager Routes
    # for a manager to see all of the requests sent to him
    get "/correctionrequests/manager/:managerID", CorrectionRequestController, :index_manager
    # for a manager to see one of the requests sent to him
    get "/correctionrequests/manager/:managerID/:id", CorrectionRequestController, :show_manager
    # for a manager to update the status of a specific requests
    put "/correctionrequests/manager/:managerID/:id", CorrectionRequestController, :update_manager

  end

  if Application.compile_env(:time_manager, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TodolistWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
