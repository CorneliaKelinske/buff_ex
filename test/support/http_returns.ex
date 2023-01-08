defmodule BuffEx.Support.HTTPReturns do
  @moduledoc """
  Returns used for the HTTP Sandbox
  """
  @canadian_protein File.read("test/support/test_responses/get_response.html.heex")

  def canadian_protein_url do
    "https://canadianprotein.com/products/micellar-casein?_pos=1&_sid=70e5bf5a3&_ss=r&variant=31928294441007"
  end

  def canadian_protein_response do
    @canadian_protein
  end

  def mock_canadian_protein_response do
    {canadian_protein_url(), fn -> canadian_protein_response() end}
  end
end
