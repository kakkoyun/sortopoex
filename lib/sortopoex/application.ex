defmodule Sortopoex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      SortopoexWeb.Endpoint,
      {RanchConnectionDrainer, ranch_ref: SortopoexWeb.Endpoint.HTTP, shutdown: 30_000}
      # Starts a worker by calling: Sortopoex.Worker.start_link(arg)
      # {Sortopoex.Worker, arg},
    ]
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sortopoex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SortopoexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
