defmodule Juice.Soundcloud do

  @moduledoc """
    Soundcloud api interface
    Handles call dispatching and responses formatting
  """

  use Supervisor

  alias Juice.Soundcloud.Track
  alias Juice.Soundcloud.User
  alias Juice.Soundcloud.ClientPool

  @records_limit 200

  # Starts a single global soundcloud client
  def start_link do
    client_id = Application.get_env(:juice, :soundcloud_client_id)
    ClientPool.start_link(client_id)
  end

  # Returns the informations for a given track
  def user(username) do
    ClientPool.fetch("/resolve", url: "http://soundcloud.com/#{username}")
    |> handle_response(User)
  end

  # Return the last 200 tracks liked by a user
  def user_likes(user_id) do
    ClientPool.fetch("/users/#{user_id}/favorites", limit: @records_limit)
    |> handle_response(Track)
  end

  # Returns the last 200 users who liked a track
  def track_likers(track_id) do
    ClientPool.fetch("/tracks/#{track_id}/favoriters", limit: @records_limit)
    |> handle_response(User)
  end

  # Handle a response, optionally converting results
  defp handle_response({:ok, response}, record_type), do: {:ok, to_record(record_type, response)}
  defp handle_response({:error, reason}, _), do: {:error, reason}

  # Conversions
  defp to_record(_type, []), do: []
  defp to_record(type, [h | t]), do: [to_record(type, h) | to_record(type, t)]
  defp to_record(type, json = %{}), do: type.from_json(json)

end
