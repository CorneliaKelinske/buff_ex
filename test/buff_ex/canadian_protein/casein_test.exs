defmodule BuffEx.CanadianProtein.CaseinTest do
  use ExUnit.Case, async: true
  alias BuffEx.CanadianProtein.Casein

  @moduletag :buff_ex_external

  describe "@find/1" do
    test "returns a tuple with :ok and a Casein struct when the HTTP request returns a valid document" do
      assert {:ok, %Casein{}} = Casein.find()
    end

    test "returns error tuple when HTTP request does not return a valid document" do
      assert {:error, _error} = Casein.find("https://canadianprotein.com/product")
    end
  end
end
