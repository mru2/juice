defmodule Juice.Soundcloud.User do

  @moduledoc """
    Structure representing a soundcloud user
  """
  defstruct [:id, :display, :track_count, :meta]

  def from_json(json) do
    %Juice.Soundcloud.User{
      id: json["id"],
      display: json["username"],
      track_count: json["public_favorites_count"],
      meta: json
    }
  end

  defimpl Inspect, for: Juice.Soundcloud.User do
    def inspect(user, opts) do
      "%User##{user.id}{ #{user.display} }"
    end
  end

end
