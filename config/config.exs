# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :juice,
  soundcloud_client_id: "3b35ba6ef2cb09c97895f4099823af7a",
  database_url: "postgresql://postgres@pg-master/juice",
  db_concurrency: 20,
  worker_concurrency: 64,
  api_concurrency: 16

config :juice, Juice.Store.Repo,
  adapter: Ecto.Adapters.Postgres,
  # > HOW DO I FUCKING REUSE THESE VALUES !!!! >
  url: "postgresql://postgres@pg-master/juice",
  size: 20
  # < HOW DO I FUCKING REUSE THESE VALUES !!!! <
