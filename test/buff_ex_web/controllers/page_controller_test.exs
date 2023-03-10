defmodule BuffExWeb.PageControllerTest do
  use BuffExWeb.ConnCase

  test "@GET /", %{conn: conn} do
    conn = get(conn, "/")

    assert html_response(conn, 302) ===
             "<html><body>You are being <a href=\"/supplements\">redirected</a>.</body></html>"
  end
end
