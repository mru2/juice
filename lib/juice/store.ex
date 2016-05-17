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
  # If too recent, returns nil
  defp upsert(record) do
    {:ok, record} = case Repo.get(record.__struct__, record.id) do
      nil -> Repo.insert record
      found ->
        # TODO : get delta_t here (dt |> Ecto.DateTime.to_erl |> :calendar.datetime_to_gregorian_seconds)
        Repo.update record
    end
  end

  # Count records
  defp count(model) do
    query = from m in model, select: count(m.id)
    Repo.one(query)
  end

end
