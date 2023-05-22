defmodule Kodala.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Kodala.Repo,
      # Start the Telemetry supervisor
      KodalaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Kodala.PubSub},
      # Start the Endpoint (http/https)
      KodalaWeb.Endpoint,
      {AshAuthentication.Supervisor, otp_app: :kodala}
      # Start a worker by calling: Kodala.Worker.start_link(arg)
      # {Kodala.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kodala.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KodalaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
