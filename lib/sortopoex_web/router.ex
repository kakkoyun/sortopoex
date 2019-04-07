defmodule SortopoexWeb.Router do
  use SortopoexWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SortopoexWeb do
    pipe_through :api
  end
end
