defmodule SortopoexWeb.Router do
  use SortopoexWeb, :router

  pipeline :api do
    plug :accepts, ["json", "text"]
  end

  scope "/api", SortopoexWeb do
    pipe_through :api

    post("/tasks/sort", TaskController, :sort)
  end

  scope "/_status", SortopoexWeb do
    pipe_through(:api)

    get("/", StatusController, :status)
    head("/", StatusController, :status)
  end
end
