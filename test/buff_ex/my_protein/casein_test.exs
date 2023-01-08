defmodule BuffEx.MyProtein.CaseinTest do
  use ExUnit.Case, async: true
  alias BuffEx.MyProtein.Casein

  @url Casein.url()

  @moduletag :buff_ex_external

  describe "@find/1" do
    test "returns a tuple with :ok and a Casein struct when the HTTP request returns a valid document" do
      assert {:ok, %Casein{}} = Casein.find(@url, sandbox?: false)
    end

    test "returns error tuple when HTTP request does not return a valid document" do
      assert {:error, _error} =
               Casein.find("https://canadianprotein.com/product", sandbox?: false)
    end
  end
end
