defmodule Juice.Soundcloud.Track do

  @moduledoc """
    Structure representing a soundcloud track
  """
  defstruct [:id, :title, :artist, :user_count]

  def from_json(json) do
    %Juice.Soundcloud.Track{
      id: json["id"],
      title: json["title"],
      artist: json["user"]["permalink"],
      user_count: json["favoritings_count"]
    }
  end

  defimpl Inspect, for: Juice.Soundcloud.Track do
    def inspect(track, opts) do
      "%Track##{track.id}{ #{track.title} }"
    end
  end

end
