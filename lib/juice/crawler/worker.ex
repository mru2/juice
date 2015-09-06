defmodule Juice.Crawler.Worker do

  alias Juice.Crawler.Queue
  alias Juice.Store
  alias Juice.Soundcloud

  def run do
    IO.puts "Starting crawler worker"
    crawl
  end

  defp crawl do
    case Queue.pop do
      nil  -> :timer.sleep(1000)
      item -> handle_crawl(item)
    end

    crawl
  end

  defp handle_crawl({:fetch_user, username}) do
    {:ok, user} = Soundcloud.user(username)
    {:ok, _record} = Store.update_node(user)

    Queue.push({:fetch_user_likes, user.id, true})
  end

  defp handle_crawl({:fetch_user_likes, user_id, enqueue_likers}) do
    {:ok, tracks} = Soundcloud.user_likes(user_id)

    Enum.each tracks, fn(track) ->
      {:ok, _record} = Store.update_node(track)
      {:ok, _record} = Store.add_like(user_id, track.id)

      if enqueue_likers, do: Queue.push({:fetch_track_likers, track.id})
    end
  end

  defp handle_crawl({:fetch_track_likers, track_id}) do
    {:ok, users} = Soundcloud.track_likers(track_id)

    Enum.each users, fn(user) ->
      {:ok, _record} = Store.update_node(user)
      {:ok, _record} = Store.add_like(user.id, track_id)
      Queue.push({:fetch_user_likes, user.id, false})
    end
  end
end
