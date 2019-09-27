defmodule ETEWeb.Router do
  use ETEWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug Phoenix.LiveView.Flash
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ETEWeb do
    pipe_through :browser

    get "/404", GameLiveController, :show
    live "/", GameBrowserLive
    live "/:id", GameLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", ETEWeb do
  #   pipe_through :api
  # end
end
