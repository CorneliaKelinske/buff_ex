defmodule BuffEx.MyProtein.Casein do
  @moduledoc """
  Defines the struct representing Casein protein available at MyProtein,
  queries the page and converts successful results into structs
  """

  alias BuffEx.HTTP

  @enforce_keys [
    :name,
    :flavour,
    :gram_quantity,
    :price,
    :price_per_hundred_gram,
    :sold_out,
    :url
  ]
  defstruct @enforce_keys

  @type t :: %__MODULE__{
          name: String.t(),
          flavour: String.t(),
          gram_quantity: integer(),
          price: integer(),
          price_per_hundred_gram: integer(),
          sold_out: boolean(),
          url: String.t()
        }

  @doc """
  Price per 83 servings and sold out cannot be obtained by a mere HTTP request. will have to be updated
  if a real scraper is implemented.
  """
  @url "https://ca.myprotein.com/sports-nutrition/slow-release-casein/11092497.html?search=casein"
  @flavour "Vanilla"
  @price_83 13_499
  @gram_quantity 2_500
  @name "Slow-Release Casein"
  @sold_out false

  @spec new(map) :: t()
  def new(casein) do
    struct!(__MODULE__, casein)
  end

  @spec find(String.t()) :: String.t() | {:error, String.t()}
  def find(url \\ @url) do
    with {:ok, document} <- HTTP.send_request_and_prep_response(url),
         {:ok, base_price} <- verify_base_price(document),
         {:ok, name} <- verify_name(document, @name) do
      casein = %{
        name: name,
        flavour: @flavour,
        gram_quantity: @gram_quantity,
        price: maybe_apply_discount(document, base_price),
        sold_out: @sold_out,
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

  defp verify_base_price(document) do
    document
    |> Floki.find(".productPrice_price")
    |> Floki.text()
    |> String.match?(~r/CA\$74.99/)
    |> case do
      true -> {:ok, @price_83}
      _ -> {:error, "Please check price"}
    end
  end

  defp verify_name(document, @name) do
    document
    |> Floki.find("h1")
    |> Floki.text()
    |> String.match?(~r/Slow-Release Casein/)
    |> case do
      true -> {:ok, @name}
      _ -> {:error, "Please check name"}
    end
  end

  defp maybe_apply_discount(document, base_price) do
    document
    |> Floki.find("#pap-banner-text-value")
    |> Floki.text()
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
