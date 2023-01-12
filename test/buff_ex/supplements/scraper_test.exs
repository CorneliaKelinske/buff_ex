defmodule BuffEx.Supplements.ScraperTest do
  use ExUnit.Case, async: true

  alias BuffEx.Scraper
  alias BuffEx.Supplements.MyProtein.Casein

  alias BuffEx.Support.ScraperReturns

  @url Casein.url()

  describe "@run_scraper/1" do
    setup do
      ScraperReturns.mock_run_scraper_flow_soldout_discount()
    end

    test "returns a tuple with :ok and a map" do
      assert {:ok, %{discount: _, price: _price, quantities: _quantities, title: _title}} =
               Scraper.run_scraper(@url)
    end
  end
end
