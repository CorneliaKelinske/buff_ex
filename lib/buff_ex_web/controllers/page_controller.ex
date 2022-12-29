defmodule BuffExWeb.PageController do
  use BuffExWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
