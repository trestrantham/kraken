defmodule Kraken.ConnectionViewTest do
  use Kraken.ConnCase, async: true
  import Phoenix.View

  test "renders index.html", %{conn: conn} do
    connections = [
      %Kraken.Provider{name: "fitbit", message: "steps", state: nil},
      %Kraken.Provider{name: "runkeeper", message: "workouts", state: "connected"}
    ]

    content = render_to_string(
      Kraken.ConnectionView,
      "index.html",
      conn: conn,
      current_user: insert_user,
      connections: connections
    )

    assert String.contains?(content, "fitbit")
    assert String.contains?(content, "runkeeper")
    refute String.contains?(content, "strava")
  end
end