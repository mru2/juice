defmodule Juice.Crawler.Queue do

  def start_link do
    Agent.start_link(fn -> :queue.new end, name: __MODULE__)
  end

  def push(item) do
    Agent.update(__MODULE__, fn queue ->
      :queue.in item, queue
    end)
  end

  def pop() do
    case Agent.get_and_update(__MODULE__, &:queue.out/1) do
      {:value, val} -> val
      :empty -> nil
    end
  end
end
