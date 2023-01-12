defmodule BuffEx.Supplements.Test do
  use ExUnit.Case, async: true
  alias BuffEx.{Supplements, Supplements.CanadianProtein, Supplements.MyProtein}
  alias BuffEx.Support.{HTTPReturns, HTTPSandbox, ScraperReturns}

  @canadian_protein_url CanadianProtein.Casein.url()
  @my_protein_url MyProtein.Casein.url()

  @canadian_casein %CanadianProtein.Casein{
    name: "Micellar Casein",
    flavour: "Vanilla",
    gram_quantity: 6_000,
    price: 15_999,
    price_per_hundred_gram: 267,
    available: true,
    url: @canadian_protein_url
  }

  @my_protein_casein %MyProtein.Casein{
    name: "Slow-Release Casein",
    flavour: "Vanilla",
    gram_quantity: 2_500,
    price: 7_424,
    price_per_hundred_gram: 124,
    available: false,
    url: @my_protein_url
  }

  describe "@all_caseins/1" do
    setup do
      Cache.SandboxRegistry.register_caches(BuffEx.BuffCache)
      HTTPSandbox.set_get_responses([HTTPReturns.mock_canadian_protein_response_available()])
      ScraperReturns.mock_run_scraper_flow_available_no_discount()
    end

    test "returns a tuple with :ok and a list of all casein proteins" do
      assert {:ok, caseins} = Supplements.all_caseins()
      assert length(caseins) === 2
    end
  end

  describe "@all_available_caseins/1" do
    test "returns a list of available caseins when caseins are available" do
      caseins = [@canadian_casein, @my_protein_casein]

      assert [@canadian_casein] = Supplements.all_available_caseins(caseins)
    end
  end

  describe "@cheapest_casein/1" do
    test "returns the cheapest casein option" do
      caseins = [@canadian_casein, @my_protein_casein]
      assert @my_protein_casein = Supplements.cheapest_casein(caseins)
    end
  end
end
