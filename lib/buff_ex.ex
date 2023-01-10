defmodule BuffEx do
  @moduledoc """
  This module is responsible for scraping and/or making requests to the protein supplier websites
  and for handling the results
  """

  alias BuffEx.Supplements.{CanadianProtein, MyProtein}

  @spec find_canadian_protein_casein(keyword) ::
          {:ok, CanadianProtein.Casein.t()} | {:error, ErrorMessage.t()}
  defdelegate find_canadian_protein_casein(opts \\ []), to: CanadianProtein.Casein, as: :find

  @spec find_my_protein_casein(keyword()) ::
          {:ok, MyProtein.Casein.t()} | {:error, ErrorMessage.t()}
  defdelegate find_my_protein_casein(opts \\ []), to: MyProtein.Casein, as: :find

  @spec cache_find_canadian_casein(keyword) ::
          {:ok, CanadianProtein.Casein.t()} | {:error, ErrorMessage.t()}
  defdelegate cache_find_canadian_casein(opts \\ []), to: CanadianProtein.Casein, as: :cache_find

  @spec cache_find_my_protein_casein(keyword) ::
          {:ok, MyProtein.Casein.t()} | {:error, ErrorMessage.t()}
  defdelegate cache_find_my_protein_casein(opts \\ []), to: MyProtein.Casein, as: :cache_find
end
