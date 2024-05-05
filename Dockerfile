FROM elixir:1.16.2-otp-26-slim

# install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git inotify-tools \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && mix local.rebar --force

# Copy mix files
COPY mix.exs mix.lock ./

RUN mix deps.get

# Lib and config
COPY lib lib
COPY config config

EXPOSE 4135

CMD ["mix", "run", "--no-halt"]
