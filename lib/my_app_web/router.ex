defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MyAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Beacon.LiveAdmin.Plug
  end

  use Beacon.Router
  use Beacon.LiveAdmin.Router

  scope "/admin" do
    pipe_through :browser
    beacon_live_admin("/")
  end

  scope "/" do
    pipe_through :browser
    beacon_site("/blog", site: :blog)
  end

  scope "/" do
    pipe_through :browser
    beacon_site("/", site: :my_site)
  end
end
