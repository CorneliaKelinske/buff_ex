defmodule BuffEx.Support.ScraperReturns do
  @moduledoc """
  Returns used for the scraper sandbox
  """
  alias BuffEx.MyProtein.{Casein, Scraper}

  @soldout_with_discount %{
    discount: " TAKE 45% OFF | USE CODE: TAKE45",
    price: [
      "\n              \n              \n\n                  \n                      CA$74.99\n                  \n\n            ",
      "CA$74.99"
    ],
    quantities: "Amount:\n33 servings\nselected",
    title: ["Slow-Release Casein", "Slow-Release Casein"]
  }

  @url Casein.url()
  def mock_run_scraper_flow do
    ScraperEx.Sandbox.set_run_task_result(
      Scraper.casein_flow(@url),
      {:ok, @soldout_with_discount}
    )
  end
end
