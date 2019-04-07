defmodule SortopoexWeb.TaskControllerTest do
  @moduledoc false

  use SortopoexWeb.ConnCase, async: true

  @input_payload """
  {
    "tasks": [
        {
            "name": "task-1",
            "command": "touch /tmp/file1"
        },
        {
            "name": "task-2",
            "command": "cat /tmp/file1",
            "requires": [
                "task-3"
            ]
        },
        {
            "name": "task-3",
            "command": "echo 'Hello World' > /tmp/file1",
            "requires": [
                "task-1"
            ]
        },
        {
            "name": "task-4",
            "command": "rm /tmp/file1",
            "requires": [
                "task-2",
                "task-3"
            ]
        }
    ]
  }
  """

  describe "taks controller" do
    test "POST /api/tasks/sort returns commans as json", %{conn: conn} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("accept", "application/json")
        |> post("/api/tasks/sort", @input_payload)

      assert response(conn, 200)

      [
        %{
          "command" => "touch /tmp/file1",
          "name" => "task-1"
        },
        %{
          "command" => "echo 'Hello World' > /tmp/file1",
          "name" => "task-3"
        },
        %{
          "command" => "cat /tmp/file1",
          "name" => "task-2"
        },
        %{
          "command" => "rm /tmp/file1",
          "name" => "task-4"
        }
      ] = json_response(conn, 200)
    end

    test "POST /api/tasks/sort returns commands as text", %{conn: conn} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("accept", "text/plain")
        |> post("/api/tasks/sort", @input_payload)

      assert response(conn, 200)
      assert response(conn, 200) =~ "#!/usr/bin/env bash"
    end
  end
end
