defmodule PhxBlogWeb.Plugs.WWWRedirect do
  # import Plug.Conn

  def init(options) do
    options
  end

  # catch local hosts and return raw conn.  Do not use an env catch for local Docker engine,
  # all containers run in a Prod env
  def call(%{host: "localhost"} = conn, _options), do: conn
  def call(%{host: "127.0.0.1"} = conn, _options), do: conn

  def call(conn, _options) do
    conn
    |> Phoenix.Controller.redirect(external: www_url(conn))
    # |> halt()
  end

  defp www_url(%{host: host} = conn)  do
    host
    |> String.split(".")
    |> List.last()
    |> (&"#{conn.scheme}://www.#{&1}").()
  end
end
