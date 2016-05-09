defmodule Juice.Crawler do

  use Supervisor

  def start_link(_opts \\ []) do
    # Supervise queue and worker (single for now, throttling at the client-level)
    # Separated since we don't want the crawler to block adds to the queue
    children = [
      supervisor(Juice.Crawler.Queue, [], [])
    ]

    opts = [strategy: :one_for_one, name: Juice.Crawler]
    Supervisor.start_link(children, opts)
  end

  def launch(username) do
    IO.puts "Launching crawling for #{username}"
    Juice.Crawler.Queue.push({:fetch_user, username})
  end

end
