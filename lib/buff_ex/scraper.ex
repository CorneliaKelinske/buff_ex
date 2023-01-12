defmodule BuffEx.Scraper do
  @moduledoc """
  Scrapes the MyProtein site in order to get information
  on protein availability and price
  """

  @defaults_opts [
    sandbox?: Mix.env() === :test
  ]

  @spec run_scraper(String.t(), keyword()) :: {:ok, map()} | {:error, ErrorMessage.t()}
  def run_scraper(url, opts \\ @defaults_opts) do
    opts = Keyword.merge(@defaults_opts, opts)

    if opts[:sandbox?] do
      ScraperEx.Sandbox.run_task_result(casein_flow(url))
    else
      ScraperEx.run_task_in_window(casein_flow(url))
    end
  end

  def casein_flow(url) do
    [
      {:navigate_to, url},
      {:read, :title, {:css, "h1"}},
      {:read, :price, {:css, ".productPrice_priceInfo"}},
      {:click, {:css, ".athenaProductVariations_dropdownSegment"}, :timer.seconds(1)},
      {:click, {:css, "[value=\"2416\"]"}, :timer.seconds(1)},
      {:read, :quantities, {:css, ".athenaProductVariations_radioBoxesSegment"}},
      ScraperEx.allow_error({:read, :discount, {:css, "#pap-banner-text-value"}})
    ]
  end
end
