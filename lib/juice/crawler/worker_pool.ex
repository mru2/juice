# Client pool
defmodule Juice.Crawler.WorkerPool do

  use Supervisor

  alias Juice.Crawler.Worker

  @pool_size 64
  @max_overflow 128

  defp pool_name() do
    :crawler_worker_pool
  end

  # Start a worker pool
  def start_link() do
    poolboy_config = [
      name: {:local, pool_name()},
      worker_module: Juice.Crawler.Worker,
      size: @pool_size,
      max_overflow: @max_overflow
    ]

    children = [
      :poolboy.child_spec(pool_name(), poolboy_config, [])
    ]

    options = [
      strategy: :one_for_one,
      name: __MODULE__
    ]

    Supervisor.start_link(children, options)
  end

end
