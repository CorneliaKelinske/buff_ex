defmodule BuffEx.Supplements do
  @moduledoc """
  Processes Casein structs for use in the UI
  """
  alias BuffEx.Config

  @caseins Config.caseins()

  @spec all_caseins(keyword()) :: {:ok, [%{}]}
  def all_caseins(opts \\ []) do
    caseins =
      Enum.map(@caseins, fn x ->
        case x.cache_find(opts) do
          {:ok, casein} -> casein
          _ -> []
        end
      end)

    {:ok, List.flatten(caseins)}
  end

  @spec all_available_caseins(list()) :: list()
  def all_available_caseins(caseins) do
    Enum.filter(caseins, &(&1.available === true))
  end

  @spec cheapest_casein(list) :: map()
  def cheapest_casein(caseins) do
    caseins
    |> Enum.sort(&(&1.price_per_hundred_gram < &2.price_per_hundred_gram))
    |> List.first()
  end
end
