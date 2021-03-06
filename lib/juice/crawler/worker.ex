defmodule Juice.Crawler.Worker do

  # Records should be updated once every day
  @update_rate 60 * 60 * 24

  alias Juice.Crawler.Queue
  alias Juice.Store
  alias Juice.Soundcloud

  def start_link(_opts) do
    Task.start_link &work/0
  end

  def work do
    case Queue.pop do
      nil -> :timer.sleep(1000)
      item ->
        IO.puts "Crawling #{inspect item}"
        handle_crawl(item)
    end
    work
  end

  defp handle_crawl({:fetch_user, username}) do
    {:ok, user} = Soundcloud.user(username)
    {:ok, _record} = Store.update_node(user)

    Queue.push({:fetch_user_likes, user.id, true})
  end

  defp handle_crawl({:fetch_user_likes, user_id, enqueue_likers}) do
    IO.puts "Crawling user likes for #{user_id}"
    {:ok, tracks} = Soundcloud.user_likes(user_id)

    Enum.each tracks, fn(track) ->
      {:ok, status} = Store.update_node(track)
      {:ok, _record} = Store.add_like(user_id, track.id)

      if enqueue_likers && enqueue_update?(status), do: Queue.push({:fetch_track_likers, track.id})
    end
  end

  defp handle_crawl({:fetch_track_likers, track_id}) do
    IO.puts "Crawling track likers for #{track_id}"
    {:ok, users} = Soundcloud.track_likers(track_id)

    Enum.each users, fn(user) ->
      {:ok, status} = Store.update_node(user)
      {:ok, _record} = Store.add_like(user.id, track_id)
      if enqueue_update?(status), do: Queue.push({:fetch_user_likes, user.id, false})
    end
  end

  defp enqueue_update?(:created), do: true
  defp enqueue_update?({:updated, last_update}) when last_update > @update_rate, do: true
  defp enqueue_update?(_), do: false

end
