defmodule BuffEx.MyProtein.Casein do
  @moduledoc """
  Defines the struct representing Casein protein available at MyProtein,
  queries the page and converts successful results into structs
  """

  alias BuffEx.MyProtein.Scraper

  @enforce_keys [
    :name,
    :flavour,
    :gram_quantity,
    :price,
    :price_per_hundred_gram,
    :available,
    :url
  ]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          name: String.t(),
          flavour: String.t(),
          gram_quantity: integer(),
          price: integer(),
          price_per_hundred_gram: integer(),
          available: boolean(),
          url: String.t()
        }

  @doc """
  Price per 83 servings cannot be reliably obtained by the scraper. Current assumption is that as long as the
  base price is the same, the price per 83 servings is unchanged as well.
  """
  @url "https://ca.myprotein.com/sports-nutrition/slow-release-casein/11092497.html?search=casein"
  @flavour "Vanilla"
  @price_83 13_499
  @gram_quantity 2_500
  @name "Slow-Release Casein"

  @spec new(map) :: t()
  def new(casein) do
    struct!(__MODULE__, casein)
  end

  @spec find(String.t()) :: {:ok, t()} | {:error, String.t()} | ErrorMessage.t()
  def find(url \\ @url) do
    with {:ok, %{price: price, quantities: quantities, title: name, discount: discount}} <-
           Scraper.run_scraper(url),
         {:ok, base_price} <- verify_base_price(price),
         {:ok, name} <- verify_name(name, @name) do
      casein = %{
        name: name,
        flavour: @flavour,
        gram_quantity: @gram_quantity,
        price: maybe_apply_discount(discount, base_price),
        available: available?(quantities),
        url: @url
      }

      casein =
        new(
          Map.merge(casein, %{
            price_per_hundred_gram: price_per_hundred_gram(casein.price, casein.gram_quantity)
          })
        )

      {:ok, casein}
    end
  end

  defp available?(quantities) do
    String.match?(quantities, ~r/83/)
  end

  defp verify_base_price([price | _]) do
    case String.match?(price, ~r/CA\$74.99/) do
      true -> {:ok, @price_83}
      _ -> {:error, "Please check price"}
    end
  end

  defp verify_name(name, @name) do
    case List.first(name) do
      "Slow-Release Casein" -> {:ok, @name}
      _ -> {:error, "Please check name"}
    end
  end

  defp maybe_apply_discount(nil, base_price) do
    base_price
  end

  defp maybe_apply_discount(discount, base_price) do
    discount
    |> then(&Regex.run(~r/\d{1,2}\%\sOFF/, &1))
    |> case do
      nil -> base_price
      [discount] -> discounted_price(discount, base_price)
    end
  end

  defp discounted_price(discount, base_price) do
    discount =
      discount
      |> String.split("%")
      |> List.first()
      |> String.to_integer()

    base_price - round(base_price * discount / 100)
  end

  defp price_per_hundred_gram(price, @gram_quantity) do
    round(price / 60)
  end
end
