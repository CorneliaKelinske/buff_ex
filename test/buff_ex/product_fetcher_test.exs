defmodule BuffEx.ProductFetcherTest do
  use ExUnit.Case, async: true

  alias BuffEx.{BuffCache, ProductFetcher}
  alias BuffEx.Support.{HTTPReturns, HTTPSandbox}

  @product BuffEx.Supplements.CanadianProtein.Casein

  setup do
    HTTPSandbox.set_get_responses([HTTPReturns.mock_canadian_protein_response_not_available()])
    Cache.SandboxRegistry.register_caches(BuffEx.BuffCache)
    ProductFetcher.start_link(@product)
    :ok
  end

  describe "@run/1" do
    test "retrieves product info and stores it in the cache" do
      Process.sleep(250)
      assert {:ok, %@product{}} = BuffCache.get("CanadianProtein.Casein")
    end
  end
end
