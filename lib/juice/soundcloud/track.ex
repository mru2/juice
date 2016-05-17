defmodule Juice.Soundcloud.Track do

  @moduledoc """
    Structure representing a soundcloud track
  """
  defstruct [:id, :display, :user_count, :meta]

  def from_json(json) do
    %Juice.Soundcloud.Track{
      id: json["id"],
      display: json["title"],
      user_count: json["favoritings_count"],
      meta: json
    }
  end

  defimpl Inspect, for: Juice.Soundcloud.Track do
    def inspect(track, opts) do
      "%Track##{track.id}{ #{track.display} }"
    end
  end

end
