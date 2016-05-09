# Client pool
defmodule Juice.Soundcloud.Pool do

  @pool_size 5
  @max_overflow 10

  # Start a worker pool
  def start_link
    poolboy_config = [
      {:name, {:local, pool_name()}},
      {:worker_module, Juice.Soundcloud.Client},
      {:size, @pool_size},
      {:max_overflow, @max_overflow}
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
