defmodule SortopoexWeb.StatusController do
  @moduledoc """
  A controller returns the status of running web service and its dependecies
  """

  use SortopoexWeb, :controller

  @spec status(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def status(%{method: "GET"} = conn, _) do
    json(conn, %{
      message: "Operational",
      version: :sortopoex |> Application.spec(:vsn) |> to_string,
      inRecovery: false
    })
  end

  def status(%{method: "HEAD"} = conn, _), do: put_status(conn, 200)
end
