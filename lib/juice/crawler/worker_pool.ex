# Client pool
defmodule Juice.Crawler.WorkerPool do

  use Supervisor

  alias Juice.Crawler.Worker

  defp pool_name() do
    :crawler_worker_pool
  end

  # Start a worker pool
  def start_link() do
    pool_size = Application.get_env(:juice, :worker_concurrency)

    IO.puts "Starting workers with a pool of #{pool_size}"

    poolboy_config = [
      name: {:local, pool_name()},
      worker_module: Juice.Crawler.Worker,
      size: pool_size,
      max_overflow: pool_size * 2
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
