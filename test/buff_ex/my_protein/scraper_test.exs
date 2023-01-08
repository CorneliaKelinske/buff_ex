defmodule BuffEx.MyProtein.ScraperTest do
  use ExUnit.Case, async: true

  alias BuffEx.MyProtein.{Casein, Scraper}
  alias BuffEx.Support.ScraperReturns

  @url Casein.url()

  describe "@run_scraper/1" do
    setup do
      ScraperReturns.mock_run_scraper_flow()
    end

    test "returns a tuple with :ok and a map" do
      assert {:ok, %{discount: _, price: _price, quantities: _quantities, title: _title}} =
               Scraper.run_scraper(@url)
    end
  end
end
