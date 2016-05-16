# Client pool
defmodule Juice.Soundcloud.ClientPool do

  use Supervisor

  alias Juice.Soundcloud.Client

  @pool_size 20
  @max_overflow 40

  defp pool_name() do
    :soundcloud_client_pool
  end

  # Start a worker pool
  def start_link(client_id) do
    poolboy_config = [
      name: {:local, pool_name()},
      worker_module: Juice.Soundcloud.Client,
      size: @pool_size,
      max_overflow: @max_overflow
    ]

    children = [
      :poolboy.child_spec(pool_name(), poolboy_config, client_id)
    ]

    options = [
      strategy: :one_for_one,
      name: __MODULE__
    ]

    Supervisor.start_link(children, options)
  end

  # Use a client in the pool to fetch data
  def fetch(url, opts \\ []) do
    :poolboy.transaction pool_name, fn(client_pid) ->
      client_pid |> Client.fetch(url, opts)
    end
  end

end
