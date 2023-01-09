defmodule BuffEx.Support.HTTPReturns do
  @moduledoc """
  Returns used for the HTTP Sandbox
  """
  @canadian_protein_unavailable File.read(
                                  "test/support/test_responses/get_response_not_available.html.heex"
                                )
  @canadian_protein_available File.read(
                                "test/support/test_responses/get_response_available.html.heex"
                              )
  def canadian_protein_url do
    "https://canadianprotein.com/products/micellar-casein?_pos=1&_sid=70e5bf5a3&_ss=r&variant=31928294441007"
  end

  def canadian_protein_response_not_available do
    @canadian_protein_unavailable
  end

  def canadian_protein_response_available do
    @canadian_protein_available
  end

  def mock_canadian_protein_response_not_available do
    {canadian_protein_url(), fn -> canadian_protein_response_not_available() end}
  end

  def mock_canadian_protein_response_available do
    {canadian_protein_url(), fn -> canadian_protein_response_available() end}
  end
end
