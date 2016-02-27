defmodule TakeAnumber.Router do
  use TakeAnumber.Web, :router

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

  scope "/", TakeAnumber do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    patch "/next/:id", PageController, :next

    resources "/user", UserController
    resources "/numbers", NumberController
  end

  # Other scopes may use custom stacks.
  # scope "/api", TakeAnumber do
  #   pipe_through :api
  # end
end
