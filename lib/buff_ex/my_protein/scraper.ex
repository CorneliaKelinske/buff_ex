defmodule BuffEx.MyProtein.Scraper do
  @moduledoc """
  Scrapes the MyProtein site in order to get information
  on protein availability and price
  """

  def run_scraper(url) do
    ScraperEx.run_task_in_window([
      {:navigate_to, url},
      {:read, :title, {:css, "h1"}},
      {:read, :price, {:css, ".productPrice_priceInfo"}},
      {:click, {:css, ".athenaProductVariations_dropdownSegment"}, :timer.seconds(1)},
      {:click, {:css, "[value=\"2416\"]"}, :timer.seconds(1)},
      {:read, :quantities, {:css, ".athenaProductVariations_radioBoxesSegment"}},
      ScraperEx.allow_error({:read, :discount, {:css, "#pap-banner-text-value"}})
    ])
  end
end
