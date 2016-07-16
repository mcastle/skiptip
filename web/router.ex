defmodule Skiptip.Router do
  use Skiptip.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Skiptip do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/facebook_logins/new", FacebookLoginController, :new
    get "/facebook_logins/callback", FacebookLoginController, :callback
  end


  scope "/api", Skiptip do
    pipe_through :api
    get "/login", FacebookLoginController, :create
    get "/places/search", PlacesController, :search
  end
end
