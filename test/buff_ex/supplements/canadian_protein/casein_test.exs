defmodule BuffEx.Supplements.CanadianProtein.CaseinTest do
  use ExUnit.Case, async: true

  alias BuffEx.BuffCache
  alias BuffEx.Supplements.CanadianProtein.Casein
  alias BuffEx.Support.{HTTPReturns, HTTPSandbox}

  @url Casein.url()

  describe "@find/1" do
    @tag :buff_ex_external
    test "returns a tuple with :ok and a Casein struct when the HTTP request returns a valid document" do
      assert {:ok, %Casein{}} = Casein.find(sandbox?: false)
    end

    test "returns a tuple with :ok and a casein struct" do
      HTTPSandbox.set_get_responses([HTTPReturns.mock_canadian_protein_response_not_available()])

      assert {:ok,
              %Casein{
                name: "Micellar Casein",
                flavour: "Vanilla",
                gram_quantity: 6_000,
                price: 15_999,
                price_per_hundred_gram: 267,
                available: false,
                url: @url
              }} = Casein.find()
    end

    test "recognizes when protein is available" do
      HTTPSandbox.set_get_responses([HTTPReturns.mock_canadian_protein_response_available()])

      assert {:ok,
              %Casein{
                name: "Micellar Casein",
                flavour: "Vanilla",
                gram_quantity: 6_000,
                price: 15_999,
                price_per_hundred_gram: 267,
                available: true,
                url: @url
              }} = Casein.find()
    end
  end

  describe "@cache_find/1" do
    setup do
      Cache.SandboxRegistry.register_caches(BuffEx.BuffCache)
    end

    @tag :buff_ex_external
    test "returns a tuple with :ok and the Casein struct scraped from the website when the cache is empty - live" do
      assert {:ok, nil} = BuffCache.get("CanadianProtein.Casein")
      assert {:ok, %Casein{flavour: "Vanilla"}} = Casein.cache_find(sandbox?: false)
    end

    @tag :buff_ex_external
    test "returns value from cache - live" do
      BuffCache.put("CanadianProtein.Casein", %Casein{
        name: "Micellar Casein",
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
      HTTPSandbox.set_get_responses([HTTPReturns.mock_canadian_protein_response_not_available()])
      assert {:ok, nil} = BuffCache.get("CanadianProtein.Casein")

      assert {:ok,
              %Casein{
                name: "Micellar Casein",
                flavour: "Vanilla",
                gram_quantity: 6_000,
                price: 15_999,
                price_per_hundred_gram: 267,
                available: false,
                url: @url
              }} = Casein.cache_find()
    end

    test "returns value from cache" do
      BuffCache.put("CanadianProtein.Casein", %Casein{
        name: "Micellar Casein",
        flavour: "Chocolate",
        gram_quantity: 6_000,
        price: 15_999,
        price_per_hundred_gram: 267,
        available: false,
        url: @url
      })

      assert {:ok, %Casein{flavour: "Chocolate"}} = Casein.cache_find()
    end
  end
end
