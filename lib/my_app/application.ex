defmodule MyApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MyAppWeb.Telemetry,
      MyApp.Repo,
      {DNSCluster, query: Application.get_env(:my_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MyApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MyApp.Finch},
      # Start a worker by calling: MyApp.Worker.start_link(arg)
      # {MyApp.Worker, arg},
      # Start to serve requests, typically the last entry
      MyAppWeb.Endpoint,
      {Beacon,
       sites: [
         [
           site: :my_site,
           repo: MyApp.Repo,
           endpoint: MyAppWeb.Endpoint,
           router: MyAppWeb.Router
         ],
         [
           site: :blog,
           repo: MyApp.Repo,
           endpoint: MyAppWeb.Endpoint,
           router: MyAppWeb.Router,
           extra_page_fields: [
             MyApp.Beacon.PageFields.Type,
             MyApp.Beacon.PageFields.Tags
           ]
         ]
         # ,
         # tailwind_config:
         #  Path.join(Application.app_dir(:my_app, "priv"), "tailwind.config.bundle.js")
       ]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MyAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
