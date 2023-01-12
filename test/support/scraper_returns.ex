defmodule BuffEx.Support.ScraperReturns do
  @moduledoc """
  Returns used for the scraper sandbox
  """
  alias BuffEx.Scraper
  alias BuffEx.Supplements.MyProtein.Casein

  @soldout_with_discount %{
    discount: " TAKE 45% OFF | USE CODE: TAKE45",
    price: [
      "\n              \n              \n\n                  \n                      CA$74.99\n                  \n\n            ",
      "CA$74.99"
    ],
    quantities: "Amount:\n33 servings\nselected",
    title: ["Slow-Release Casein", "Slow-Release Casein"]
  }

  @available_no_discount %{
    discount: nil,
    price: [
      "\n              \n              \n\n                  \n                      CA$74.99\n                  \n\n            ",
      "CA$134.99"
    ],
    quantities: "Amount:\n33 servings\nselected  Amount:\n83 servings\nselected",
    title: ["Slow-Release Casein", "Slow-Release Casein"]
  }

  @price_change %{
    discount: " TAKE 45% OFF | USE CODE: TAKE45",
    price: [
      "\n              \n              \n\n                  \n                      CA$75.99\n                  \n\n            ",
      "CA$75.99"
    ],
    quantities: "Amount:\n33 servings\nselected",
    title: ["Slow-Release Casein", "Slow-Release Casein"]
  }

  @url Casein.url()
  def mock_run_scraper_flow_soldout_discount do
    ScraperEx.Sandbox.set_run_task_result(
      Scraper.casein_flow(@url),
      {:ok, @soldout_with_discount}
    )
  end

  def mock_run_scraper_flow_available_no_discount do
    ScraperEx.Sandbox.set_run_task_result(
      Scraper.casein_flow(@url),
      {:ok, @available_no_discount}
    )
  end

  def mock_run_scraper_flow_price_change do
    ScraperEx.Sandbox.set_run_task_result(
      Scraper.casein_flow(@url),
      {:ok, @price_change}
    )
  end
end
