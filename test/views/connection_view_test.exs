defmodule Kraken.ConnectionViewTest do
  use Kraken.ConnCase, async: true
  import Phoenix.View

  test "renders index.html", %{conn: conn} do
    content = render_to_string(
      Kraken.ConnectionView,
      "index.html",
      conn: conn,
      current_user: insert_user,
      providers: [
        %{name: "fitbit", message: "steps", state: "available"},
        %{name: "runkeeper", message: "workouts", state: "available"}
      ]
    )

    assert String.contains?(content, "fitbit")
    assert String.contains?(content, "runkeeper")
    refute String.contains?(content, "strava")
  end
end
