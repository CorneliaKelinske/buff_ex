defmodule BuffEx.CanadianProtein.HTTPTest do
  use ExUnit.Case, async: true

  alias BuffEx.CanadianProtein.{Casein, HTTP}
  alias BuffEx.Support.{HTTPReturns, HTTPSandbox}

  @url Casein.url()

  describe "@send_request_and_prep_response/2" do
    test "returns tuple with :ok and a document parsed by Floki" do
      HTTPSandbox.set_get_responses([HTTPReturns.mock_canadian_protein_response_not_available()])

      assert {:ok, _} = HTTP.send_request_and_prep_response(@url)
    end
  end
end
