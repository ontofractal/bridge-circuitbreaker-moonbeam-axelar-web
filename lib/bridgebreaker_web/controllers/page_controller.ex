defmodule BridgebreakerWeb.PageController do
  use BridgebreakerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
