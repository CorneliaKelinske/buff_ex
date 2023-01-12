defmodule BuffEx.BuffCache do
  @moduledoc """
  Caches the latest casein protein information from MyProtein and
  CanadianProtein
  """

  use Cache,
    adapter: Cache.ETS,
    name: :buff_cache,
    sandbox?: Mix.env() === :test,
    opts: []
end
