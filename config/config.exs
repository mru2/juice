# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :juice,
  soundcloud_client_id: "3b35ba6ef2cb09c97895f4099823af7a",
  worker_concurrency: 64,
  api_concurrency: 16

config :juice, Juice.Store.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "postgresql://postgres@pg-master/juice",
  size: 20
