defmodule PhxBlogWeb.SoftwareController do
  use PhxBlogWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
