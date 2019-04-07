defmodule SortopoexWeb.TaskController do
  @moduledoc """
  A controller that handles Task related buiness logic
  """

  use SortopoexWeb, :controller

  alias Sortopoex.Tasks

  @spec sort(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def sort(conn, params) do
    case get_req_header(conn, "accept") do
      ["application/json"] ->
        tasks =
          params
          |> Map.get("tasks")
          |> Tasks.sort()
          |> Enum.map(&Map.take(&1, ["name", "command"]))

        pretty_json(conn, tasks)

      _ ->
        commands =
          params
          |> Map.get("tasks")
          |> Tasks.sort()
          |> Enum.map(& &1["command"])
          |> List.insert_at(0, "#!/usr/bin/env bash\n")
          |> Enum.join("\n")

        send_resp(conn, :ok, commands)
    end
  end

  # Helpers

  @spec pretty_json(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def pretty_json(conn, data) do
    conn
    |> Plug.Conn.put_resp_header("content-type", "application/json")
    |> Plug.Conn.send_resp(200, Jason.encode!(data, pretty: true))
  end
end
