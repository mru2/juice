defmodule Juice.Soundcloud.Track do

  @moduledoc """
    Structure representing a soundcloud track
  """
  defstruct [:id, :title, :user_name, :user_id, :user_count]

  def from_json(json) do
    %Juice.Soundcloud.Track{
      id: json["id"],
      title: json["title"],
      user_id: json["user"]["id"],
      user_name: json["user"]["permalink"],
      user_count: json["favoritings_count"]
    }
  end

  defimpl Inspect, for: Juice.Soundcloud.Track do
    def inspect(track, opts) do
      "%Track##{track.id}{ #{track.title} }"
    end
  end

end
