defmodule BuffEx do
  @moduledoc """
  This module is responsible for scraping and/or making requests to the protein supplier websites
  and for handling the results
  """

  alias BuffEx.{CanadianProtein, MyProtein}

  @spec canadian_protein_casein(keyword) ::
          {:ok, CanadianProtein.Casein.t()} | {:error, ErrorMessage.t()}
  defdelegate canadian_protein_casein(opts \\ []), to: CanadianProtein.Casein, as: :find

  @spec my_protein_casein(keyword()) ::
          {:ok, MyProtein.Casein.t()} | {:error, ErrorMessage.t()}
  defdelegate my_protein_casein(opts \\ []), to: MyProtein.Casein, as: :find
end
