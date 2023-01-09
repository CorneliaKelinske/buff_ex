defmodule BuffEx.ProteinCache do
  @moduledoc """
  Caches the latest casein protein information from MyProtein and
  CanadianProtein
  """

  use Cache,
    adapter: Cache.ETS,
    name: :casein_protein,
    sandbox?: Mix.env() === :test,
    opts: []
end
