defmodule BuffEx.Supplements.ProteinCache do
  @moduledoc """
  Caches the latest casein protein information from MyProtein and
  CanadianProtein
  """

  use Cache,
    adapter: Cache.ETS,
    name: :protein_cache,
    sandbox?: Mix.env() === :test,
    opts: []
end
