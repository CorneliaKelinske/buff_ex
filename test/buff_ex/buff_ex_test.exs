defmodule BuffExTest do
  use ExUnit.Case, async: true

  alias BuffEx.{CanadianProtein, MyProtein, ProteinCache}
  alias BuffEx.Support.{HTTPReturns, HTTPSandbox, ScraperReturns}
  @canadian_protein_url CanadianProtein.Casein.url()
  @my_protein_url MyProtein.Casein.url()

  setup do
    Cache.SandboxRegistry.register_caches(BuffEx.ProteinCache)
  end

  describe "@find_canadian_protein_casein/1" do
    test "returns a tuple with :ok and a CanadianProtein casein struct" do
      HTTPSandbox.set_get_responses([HTTPReturns.mock_canadian_protein_response_not_available()])

      assert {:ok,
              %BuffEx.CanadianProtein.Casein{
                name: "Micellar Casein",
                flavour: "Vanilla",
                gram_quantity: 6_000,
                price: 15_999,
                price_per_hundred_gram: 267,
                available: false,
                url: @canadian_protein_url
              }} = BuffEx.find_canadian_protein_casein()
    end

    test "recognizes when protein is available" do
      HTTPSandbox.set_get_responses([HTTPReturns.mock_canadian_protein_response_available()])

      assert {:ok,
              %BuffEx.CanadianProtein.Casein{
                name: "Micellar Casein",
                flavour: "Vanilla",
                gram_quantity: 6_000,
                price: 15_999,
                price_per_hundred_gram: 267,
                available: true,
                url: @canadian_protein_url
              }} = BuffEx.find_canadian_protein_casein()
    end
  end

  describe "@find_my_protein_casein/1" do
    test "returns a tuple with :ok and a MyProtein casein struct" do
      ScraperReturns.mock_run_scraper_flow_soldout_discount()

      assert {:ok,
              %BuffEx.MyProtein.Casein{
                name: "Slow-Release Casein",
                flavour: "Vanilla",
                gram_quantity: 2_500,
                price: 7_424,
                price_per_hundred_gram: 124,
                available: false,
                url: @my_protein_url
              }} = BuffEx.find_my_protein_casein()
    end

    test "recognizes when casein is available and not discounted" do
      ScraperReturns.mock_run_scraper_flow_available_no_discount()

      assert {:ok,
              %BuffEx.MyProtein.Casein{
                name: "Slow-Release Casein",
                flavour: "Vanilla",
                gram_quantity: 2_500,
                price: 13_499,
                price_per_hundred_gram: 225,
                available: true,
                url: @my_protein_url
              }} = BuffEx.find_my_protein_casein()
    end

    test "recognizes price change" do
      ScraperReturns.mock_run_scraper_flow_price_change()

      assert {:error,
              %ErrorMessage{
                code: :expectation_failed,
                message: "Please check price",
                details: nil
              }} = BuffEx.find_my_protein_casein()
    end
  end

  describe "@cache_find_canadian_casein/1" do
    test "returns a tuple with :ok and casein struct from website when the cache is empty" do
      HTTPSandbox.set_get_responses([HTTPReturns.mock_canadian_protein_response_not_available()])
      assert {:ok, nil} = ProteinCache.get("canadian_protein")

      assert {:ok,
              %CanadianProtein.Casein{
                name: "Micellar Casein",
                flavour: "Vanilla",
                gram_quantity: 6_000,
                price: 15_999,
                price_per_hundred_gram: 267,
                available: false,
                url: @canadian_protein_url
              }} = BuffEx.cache_find_canadian_casein()
    end

    test "returns value from cache" do
      ProteinCache.put("canadian_protein", %CanadianProtein.Casein{
        name: "Micellar Casein",
        flavour: "Chocolate",
        gram_quantity: 6_000,
        price: 15_999,
        price_per_hundred_gram: 267,
        available: false,
        url: @canadian_protein_url
      })

      assert {:ok, %CanadianProtein.Casein{flavour: "Chocolate"}} =
               BuffEx.cache_find_canadian_casein(sandbox?: false)
    end
  end

  describe "@cache_find_my_protein_casein/1" do
    test "returns a tuple with :ok and casein struct from website when the cache is empty" do
      ScraperReturns.mock_run_scraper_flow_soldout_discount()
      assert {:ok, nil} = ProteinCache.get("my_protein")

      assert {:ok,
              %MyProtein.Casein{
                name: "Slow-Release Casein",
                flavour: "Vanilla",
                gram_quantity: 2_500,
                price: 7_424,
                price_per_hundred_gram: 124,
                available: false,
                url: @my_protein_url
              }} = BuffEx.cache_find_my_protein_casein()
    end

    test "returns value from cache" do
      ProteinCache.put("my_protein", %MyProtein.Casein{
        name: "Slow-Release Casein",
        flavour: "Chocolate",
        gram_quantity: 2_500,
        price: 7_424,
        price_per_hundred_gram: 124,
        available: false,
        url: @my_protein_url
      })

      assert {:ok, %MyProtein.Casein{flavour: "Chocolate"}} =
               BuffEx.cache_find_my_protein_casein()
    end
  end
end
