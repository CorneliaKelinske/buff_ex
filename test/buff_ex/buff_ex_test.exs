defmodule BuffExTest do
  use ExUnit.Case, async: true

  alias BuffEx.{CanadianProtein, MyProtein}
  alias BuffEx.Support.{HTTPReturns, HTTPSandbox, ScraperReturns}
  @canadian_protein_url CanadianProtein.Casein.url()
  @my_protein_url MyProtein.Casein.url()

  describe "@canadian_protein_casein/1" do
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
              }} = BuffEx.canadian_protein_casein()
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
              }} = BuffEx.canadian_protein_casein()
    end
  end

  describe "@my_protein_casein/1" do
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
              }} = BuffEx.my_protein_casein()
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
              }} = BuffEx.my_protein_casein()
    end

    test "recognizes price change" do
      ScraperReturns.mock_run_scraper_flow_price_change()

      assert {:error, "Please check price"} = BuffEx.my_protein_casein()
    end
  end
end
