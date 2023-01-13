defmodule BuffExWeb.SupplementsLive.IndexTest do
  use ExUnit.Case, async: true
  use BuffExWeb.ConnCase

  import Phoenix.LiveViewTest

  alias BuffEx.Supplements.MyProtein.Casein
  alias BuffEx.Support.ScraperReturns
  alias BuffEx.Support.{HTTPReturns, HTTPSandbox}

  @url Casein.url()

  describe "@index" do
    test "displays page with link to cheapest casein when options are available", %{conn: conn} do
      Cache.SandboxRegistry.register_caches(BuffEx.BuffCache)
      HTTPSandbox.set_get_responses([HTTPReturns.mock_canadian_protein_response_not_available()])
      ScraperReturns.mock_run_scraper_flow_available_no_discount()

      {:ok, _index_live, html} = live(conn, Routes.supplements_index_path(conn, :index))
      assert html =~ "Vanilla Casein Protein"
      assert html =~ @url
    end

    test "displays protein emergency when no options are available", %{conn: conn} do
      Cache.SandboxRegistry.register_caches(BuffEx.BuffCache)
      HTTPSandbox.set_get_responses([HTTPReturns.mock_canadian_protein_response_not_available()])
      ScraperReturns.mock_run_scraper_flow_soldout_discount()

      {:ok, _index_live, html} = live(conn, Routes.supplements_index_path(conn, :index))
      assert html =~ "Vanilla Casein Protein"
      assert html =~ "Protein emergency!"
    end
  end
end
