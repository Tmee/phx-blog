# Use an official Elixir image as the builder
FROM hexpm/elixir:1.14.0-erlang-25.0.3-debian-bullseye-20210902-slim as builder

# Install build dependencies
RUN apt-get update -y && \
    apt-get install -y build-essential git curl && \
    apt-get clean && \
    rm -f /var/lib/apt/lists/*_*

# Set the working directory
WORKDIR /app

# Install Hex and Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set the build environment
ENV MIX_ENV="prod"

# Install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV

# Create a directory for compile-time config files
RUN mkdir config

# Copy compile-time config files before compiling dependencies
# This ensures that relevant config changes trigger recompilation
COPY config/config.exs config/${MIX_ENV}.exs config/

# ... (Add any other necessary steps for your specific project)

# Use a separate runtime image
FROM hexpm/elixir:1.14.0-erlang-25.0.3-debian-bullseye-20210902-slim

WORKDIR /release

COPY --from=builder --chown=release:release /app/_build/prod/rel/phx_blog .
COPY --chown=release:release ./docker/startup.sh /usr/local/bin/startup.sh

RUN chmod +x /usr/local/bin/startup.sh

USER release
EXPOSE 4000

CMD ["startup.sh"]