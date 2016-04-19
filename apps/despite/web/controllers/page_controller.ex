defmodule Despite.PageController do
  use Despite.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
