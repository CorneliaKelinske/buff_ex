defmodule BuffEx.CanadianProtein.Casein do
  @moduledoc """
  Defines the struct representing Casein protein available at Canadian Protein,
  queries the page and converts successful results into structs
  """

  alias BuffEx.HTTP

  @url "https://canadianprotein.com/products/micellar-casein?_pos=1&_sid=70e5bf5a3&_ss=r&variant=31928294441007"

  def find do
    with {:ok, document} <- HTTP.send_request_and_prep_response(@url) do
      Floki.find(document, "#ProductPrice") |> Floki.text()
    end
  end
end
