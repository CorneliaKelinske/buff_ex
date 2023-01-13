defmodule BuffExWeb.PageController do
  use BuffExWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/supplements")
  end
end
