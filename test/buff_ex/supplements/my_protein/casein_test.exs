defmodule BuffEx.Supplements.MyProtein.CaseinTest do
  use ExUnit.Case, async: true
  alias BuffEx.Supplements.{MyProtein.Casein, ProteinCache}
  alias BuffEx.Support.ScraperReturns

  @url Casein.url()

  describe "@find/1" do
    @tag :buff_ex_external
    test "returns a tuple with :ok and a Casein struct when the HTTP request returns a valid document - live" do
      assert {:ok, %Casein{}} = Casein.find(sandbox?: false)
    end

    test "returns a tuple with :ok and a MyProtein casein struct" do
      ScraperReturns.mock_run_scraper_flow_soldout_discount()

      assert {:ok,
              %Casein{
                name: "Slow-Release Casein",
                flavour: "Vanilla",
                gram_quantity: 2_500,
                price: 7_424,
                price_per_hundred_gram: 124,
                available: false,
                url: @url
              }} = Casein.find()
    end

    test "recognizes when casein is available and not discounted" do
      ScraperReturns.mock_run_scraper_flow_available_no_discount()

      assert {:ok,
              %Casein{
                name: "Slow-Release Casein",
                flavour: "Vanilla",
                gram_quantity: 2_500,
                price: 13_499,
                price_per_hundred_gram: 225,
                available: true,
                url: @url
              }} = Casein.find()
    end

    test "recognizes price change" do
      ScraperReturns.mock_run_scraper_flow_price_change()

      assert {:error,
              %ErrorMessage{
                code: :expectation_failed,
                message: "Please check price",
                details: nil
              }} = Casein.find()
    end
  end

  describe "@cache_find/1" do
    setup do
      Cache.SandboxRegistry.register_caches(BuffEx.Supplements.ProteinCache)
    end

    @tag :buff_ex_external
    test "returns a tuple with :ok and the Casein struct scraped from the website when the cache is empty - live" do
      assert {:ok, nil} = ProteinCache.get("my_protein")
      assert {:ok, %Casein{flavour: "Vanilla"}} = Casein.cache_find(sandbox?: false)
    end

    @tag :buff_ex_external
    test "returns value from cache - live" do
      ProteinCache.put("my_protein", %Casein{
        name: "Slow-Release Casein",
        flavour: "Chocolate",
        gram_quantity: 2_500,
        price: 13_499,
        price_per_hundred_gram: 225,
        available: false,
        url: @url
      })

      assert {:ok, %Casein{flavour: "Chocolate"}} = Casein.cache_find(sandbox?: false)
    end

    test "returns a tuple with :ok and casein struct from website when the cache is empty" do
      ScraperReturns.mock_run_scraper_flow_soldout_discount()
      assert {:ok, nil} = ProteinCache.get("my_protein")

      assert {:ok,
              %Casein{
                name: "Slow-Release Casein",
                flavour: "Vanilla",
                gram_quantity: 2_500,
                price: 7_424,
                price_per_hundred_gram: 124,
                available: false,
                url: @url
              }} = Casein.cache_find()
    end

    test "returns value from cache" do
      ProteinCache.put("my_protein", %Casein{
        name: "Slow-Release Casein",
        flavour: "Chocolate",
        gram_quantity: 2_500,
        price: 7_424,
        price_per_hundred_gram: 124,
        available: false,
        url: @url
      })

      assert {:ok, %Casein{flavour: "Chocolate"}} = Casein.cache_find()
    end
  end
end
