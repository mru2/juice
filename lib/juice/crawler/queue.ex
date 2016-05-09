defmodule Juice.Crawler.Queue do

  # No queue, do everything as fast as we can
  def start_link do
    Task.Supervisor.start_link(name: __MODULE__)
  end

  def push(item) do
    Task.Supervisor.start_child(__MODULE__, Juice.Crawler.Worker, :run, [item])
  end

end
