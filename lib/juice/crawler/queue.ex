defmodule Juice.Crawler.Queue do

  alias Juice.JobQueue

  # Wrapper around the job queue
  def start_link(opts \\ []), do: Agent.start_link(JobQueue, :new, [], name: __MODULE__)
  def pop, do: Agent.get_and_update(__MODULE__, JobQueue, :pop, [])
  def push(item), do: Agent.update(__MODULE__, JobQueue, :push, [item])
  def count, do: Agent.get(__MODULE__, JobQueue, :count, [])

end
