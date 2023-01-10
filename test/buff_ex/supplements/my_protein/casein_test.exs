defmodule BuffEx.Supplements.MyProtein.CaseinTest do
  use ExUnit.Case, async: true
  alias BuffEx.Supplements.{MyProtein.Casein, ProteinCache}

  @url Casein.url()

  @moduletag :buff_ex_external

  describe "@find/1" do
    test "returns a tuple with :ok and a Casein struct when the HTTP request returns a valid document" do
      assert {:ok, %Casein{}} = Casein.find(sandbox?: false)
    end
  end

  describe "@cache_find/1" do
    setup do
      Cache.SandboxRegistry.register_caches(BuffEx.Supplements.ProteinCache)
    end

    test "returns a tuple with :ok and the Casein struct scraped from the website when the cache is empty" do
      assert {:ok, nil} = ProteinCache.get("my_protein")
      assert {:ok, %Casein{flavour: "Vanilla"}} = Casein.cache_find(sandbox?: false)
    end

    test "returns value from cache" do
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
  end
end
