defmodule BuffEx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias BuffEx.Config

  @impl true
  def start(_type, _args) do
    children =
      [
        {Finch, name: BuffEx.Finch},
        # Start the Ecto repository
        BuffEx.Repo,
        # Start the Telemetry supervisor
        BuffExWeb.Telemetry,
        # Start the PubSub system
        {Phoenix.PubSub, name: BuffEx.PubSub},
        # Start the Endpoint (http/https)
        BuffExWeb.Endpoint,

        # Start a worker by calling: BuffEx.Worker.start_link(arg)
        # {BuffEx.Worker, arg}
        {Cache, [BuffEx.BuffCache]}
      ] ++ product_fetchers()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BuffEx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BuffExWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  if Mix.env() === :test do
    def product_fetchers do
      []
    end
  else
    @products Config.caseins()
    def product_fetchers do
      for product <- @products do
        BuffEx.ProductFetcher.child_spec(product)
      end
    end
  end
end
