defmodule KodalaWeb.Router do
  use KodalaWeb, :router
  use AshAuthentication.Phoenix.Router
  import AshAdmin.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {KodalaWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug :get_actor_from_token
    plug AshGraphql.Plug
  end
  
  scope "/" do
    pipe_through :browser
    ash_admin "/admin"
  end

  scope "/", KodalaWeb do
    pipe_through :browser

    sign_in_route()
    sign_out_route AuthController
    auth_routes_for Kodala.Accounts.User, to: AuthController
    reset_route []

    get "/", PageController, :index
  end

  scope "/" do
    pipe_through [:graphql]
    
    forward "/gql", Absinthe.Plug, schema: Kodala.Schema
  
    forward "/playground",
            Absinthe.Plug.GraphiQL,
            schema: Kodala.Schema,
            interface: :playground
  end

  # Other scopes may use custom stacks.
  # scope "/api", KodalaWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: KodalaWeb.Telemetry

    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  def get_actor_from_token(conn, _opts) do
    with ["" <> token] <- get_req_header(conn, "authorization"),
        {:ok, user, _claims} <- Kodala.Guardian.resource_from_token(token) do
     conn
     |> Ash.PlugHelpers.set_actor(user)
   else
   _ -> conn
   end
 end
end
