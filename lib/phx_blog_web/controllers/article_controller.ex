defmodule PhxBlogWeb.ArticleController do
  use PhxBlogWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end

  def aws_docker(conn, _params) do
    render(conn, :aws_docker)
  end
end
