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
  def update_node(track = %Juice.Soundcloud.Track{}), do: upsert(%Track{id: track.id, display: track.display, user_count: track.user_count, meta: track.meta})

  # Add / update a user
  def update_node(user = %Juice.Soundcloud.User{}), do: upsert(%User{id: user.id, display: user.display, track_count: user.track_count, meta: user.meta})

  # Counts
  def user_count, do: count(User)
  def track_count, do: count(Track)

  # Add a like
  def add_like(user_id, track_id) do
    {:ok, like} = case Repo.get_by(Like, user_id: user_id, track_id: track_id) do
      nil -> Repo.insert %Like{user_id: user_id, track_id: track_id}
      like -> {:ok, like}
    end
  end

  # Upsert a record
  defp upsert(record) do
    case Repo.get(record.__struct__, record.id) do
      nil ->
        Repo.insert record
        {:ok, :created}
      found ->
        delta_t = last_update(found)
        Repo.update %{found | meta: record.meta}
        {:ok, {:updated, delta_t}}
    end
  end

  # Count records
  defp count(model) do
    query = from m in model, select: count(m.id)
    Repo.one(query)
  end

  # Seconds since last update
  defp last_update(record) do
    updated_at = record.updated_at |> Ecto.DateTime.to_erl |> :calendar.datetime_to_gregorian_seconds
    now = :calendar.local_time |> :calendar.datetime_to_gregorian_seconds
    now - updated_at
  end

end
