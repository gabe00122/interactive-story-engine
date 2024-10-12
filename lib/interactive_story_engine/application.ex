defmodule InteractiveStoryEngine.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      InteractiveStoryEngineWeb.Telemetry,
      InteractiveStoryEngine.Repo,
      {DNSCluster, query: Application.get_env(:interactive_story_engine, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: InteractiveStoryEngine.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: InteractiveStoryEngine.Finch},
      # Start a worker by calling: InteractiveStoryEngine.Worker.start_link(arg)
      # {InteractiveStoryEngine.Worker, arg},
      # Start to serve requests, typically the last entry
      InteractiveStoryEngineWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InteractiveStoryEngine.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    InteractiveStoryEngineWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
