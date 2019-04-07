defmodule SortopoexWeb.TaskController do
  @moduledoc """
  A controller that handles Task related buiness logic
  """

  use SortopoexWeb, :controller

  alias Sortopoex.Tasks

  @spec sort(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def sort(conn, params) do
    case get_req_header(conn, "accept") do
      ["application/json"] -> handle_json(conn, params)
      _ -> handle_text(conn, params)
    end
  end

  # Helpers

  defp handle_json(conn, params) do
    params
    |> Map.get("tasks")
    |> Tasks.sort()
    |> case do
      {:ok, sorted} ->
        tasks = sorted |> Enum.map(&Map.take(&1, ["name", "command"]))
        pretty_json(conn, 200, tasks)

      {:error, message} ->
        pretty_json(conn, 400, %{error: message})
    end
  end

  defp handle_text(conn, params) do
    params
    |> Map.get("tasks")
    |> Tasks.sort()
    |> case do
      {:ok, sorted} ->
        commands =
          sorted
          |> Enum.map(& &1["command"])
          |> List.insert_at(0, "#!/usr/bin/env bash\n")
          |> Enum.join("\n")

        send_resp(conn, :ok, commands)

      {:error, message} ->
        send_resp(conn, :bad_request, message)
    end
  end

  defp pretty_json(conn, status, data) do
    conn
    |> Plug.Conn.put_resp_header("content-type", "application/json")
    |> Plug.Conn.send_resp(status, Jason.encode!(data, pretty: true))
  end
end
