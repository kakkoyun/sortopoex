defmodule SortopoexWeb.StatusControllerTest do
  @moduledoc false

  use SortopoexWeb.ConnCase, async: true

  describe "status controller" do
    test "GET /_status returns operational", %{conn: conn} do
      conn = get(conn, "/_status")

      %{"inRecovery" => in_recovery, "message" => message, "version" => version} = json_response(conn, 200)

      assert Version.parse!(version)
      refute in_recovery
      assert message == "Operational"
    end

    test "HEAD /_status returns 200", %{conn: conn} do
      conn = head(conn, "/_status")

      assert response(conn, 200)
    end
  end
end
