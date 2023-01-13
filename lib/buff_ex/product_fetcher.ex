defmodule BuffEx.ProductFetcher do
  @moduledoc """
  Regularly fetches product info from the corresponding websites
  """

  use Task, restart: :permanent
  require Logger
  alias BuffEx.BuffCache

  @spec start_link(module) :: {:ok, pid}
  def start_link(product_module) do
    Task.start_link(__MODULE__, :run, [product_module])
  end

  @spec child_spec(module()) :: Supervisor.child_spec()
  def child_spec(product_module) do
    %{
      id: name(product_module),
      start: {__MODULE__, :start_link, [product_module]}
    }
  end

  @spec run(module) :: :no_return
  def run(product_module) do
    case product_module.find() do
      {:ok, casein} ->
        BuffCache.put(key(product_module), 9_000, casein)

      error ->
        Logger.error(
          "Could not obtain product info for #{product_module}. Reason: #{inspect(error)}"
        )
    end

    Process.sleep(:timer.seconds(7_200))
    run(product_module)
  end

  defp name(product_module) do
    :"product_fetcher_#{product_module}"
  end

  defp key(product_module) do
    product_module
    |> Atom.to_string()
    |> String.replace("Elixir.BuffEx.Supplements.", "")
  end
end
