defmodule Juice.Store do

  import Ecto.Query

  alias Juice.Store.Repo
  alias Juice.Store.Track
  alias Juice.Store.User
  alias Juice.Store.Like

  # Start the database connection
  def start_link do
    Repo.start_link
  end

  # Add / update a track
  def update_node(track = %Juice.Soundcloud.Track{}), do: upsert(%Track{id: track.id, artist: track.artist, title: track.title, user_count: track.user_count})

  # Add / update a user
  def update_node(user = %Juice.Soundcloud.User{}), do: upsert(%User{id: user.id, name: user.name, track_count: user.track_count})

  # Add a like
  def add_like(user_id, track_id) do
    {:ok, like} = case Repo.get_by(Like, user_id: user_id, track_id: track_id) do
      nil -> Repo.insert %Like{user_id: user_id, track_id: track_id}
      like -> {:ok, like}
    end
  end

  # Upsert a record
  defp upsert(record) do
    {:ok, record} = case Repo.get(record.__struct__, record.id) do
      nil -> Repo.insert record
      found -> Repo.update record
    end
  end

end
