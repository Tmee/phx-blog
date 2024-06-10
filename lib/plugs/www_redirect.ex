defmodule PhxBlogWeb.Plugs.WWWRedirect do
  import Plug.Conn

  def init(options) do
    options
  end

  # catch local hosts and return raw conn.  Do not use an env catch for local Docker engine,
  # all containers run in a Prod env
  # def call(%{host: "localhost"} = conn, _options), do: conn
  # def call(%{host: "127.0.0.1"} = conn, _options), do: conn

  # def call(conn, _options) do
  #   conn
  #   |> Phoenix.Controller.redirect(external: www_url(conn))
  #   |> halt()
  # end

  # defp www_url(%{host: host} = conn)  do
  #   host
  #   |> String.split(".")
  #   |> List.last()
  #   |> (&"#{conn.scheme}://www.#{&1}#{conn.request_path}").()
  # end
  def call(conn, _options) do
    if bare_domain?(conn.host) do
      conn
      |> Phoenix.Controller.redirect(external: www_url(conn))
      |> halt
    else
      # Since all plugs need to return a connection
      conn
    end
  end

  # Returns URL with www prepended for the given connection. Note this also
  # applies to hosts that already contain "www"
  defp www_url(%{query_string: ""} = conn) do
    "#{conn.scheme}://www.#{conn.host}#{conn.request_path}"
  end

  defp www_url(conn) do
    "#{conn.scheme}://www.#{conn.host}#{conn.request_path}?#{conn.query_string}"
  end

  # Returns whether the domain is bare (no www)
  defp bare_domain?(host) do
    !Regex.match?(~r/\Awww\..*\z/i, host)
  end
end
