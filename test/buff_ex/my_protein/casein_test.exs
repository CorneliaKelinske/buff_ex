defmodule BuffEx.MyProtein.CaseinTest do
  use ExUnit.Case, async: true
  alias BuffEx.MyProtein.Casein

  @moduletag :buff_ex_external

  describe "@find/1" do
    test "returns a tuple with :ok and a Casein struct when the HTTP request returns a valid document" do
      assert {:ok, %Casein{}} = Casein.find(sandbox?: false)
    end
  end
end
