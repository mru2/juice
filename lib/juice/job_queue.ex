defmodule Juice.JobQueue do

  # Gonna keep it simple with just a naive list for now
  def new do
    []
  end

  # TODO : better handle priority and bumps (also depth handling)
  def push(queue, item) do
    case Enum.member?(queue, item) do
      true -> queue
      false -> [item | queue]
    end
  end

  def pop([]), do: {nil, []}

  def pop(queue) do
    [item | rest] = :lists.reverse(queue)
    {item, :lists.reverse(rest)}
  end

  def count(queue) do
    Enum.count(queue)
  end

end
