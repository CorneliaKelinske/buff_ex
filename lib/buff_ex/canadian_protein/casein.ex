defmodule BuffEx.CanadianProtein.Casein do
  @moduledoc """
  Defines the struct representing Casein protein available at Canadian Protein,
  queries the page and converts successful results into structs
  """

  alias BuffEx.CanadianProtein.HTTP

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

  @url "https://canadianprotein.com/products/micellar-casein?_pos=1&_sid=70e5bf5a3&_ss=r&variant=31928294441007"
  @flavour "Vanilla"
  @gram_quantity 6_000

  @spec new(map) :: t()
  def new(casein) do
    struct!(__MODULE__, casein)
  end

  @spec find(String.t()) :: {:ok, t()} | {:error, String.t()}
  def find(url \\ @url) do
    with {:ok, document} <- HTTP.send_request_and_prep_response(url) do
      casein = %{
        name: name(document),
        flavour: @flavour,
        gram_quantity: @gram_quantity,
        price: price(document),
        available: available?(document),
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

  defp name(document) do
    document
    |> Floki.find(".proBoxInfo h1")
    |> Floki.text()
  end

  defp available?(document) do
    case Floki.find(document, ".bigsoldout") do
      [] -> true
      _ -> false
    end
  end

  defp price(document) do
    document
    |> Floki.find("#ProductPrice")
    |> Floki.text()
    |> String.split("$")
    |> List.last()
    |> String.trim()
    |> String.to_float()
    |> to_cents()
    |> maybe_apply_discount(document)
  end

  defp to_cents(float) do
    round(float * 100)
  end

  defp maybe_apply_discount(price, document) do
    document
    |> Floki.find("script")
    |> Floki.raw_html()
    |> then(&Regex.run(~r/\d{1,2}\%\sOFF/, &1))
    |> case do
      nil -> price
      discount -> discounted_price(discount, price)
    end
  end

  defp discounted_price([discount | _], price) do
    discount =
      discount
      |> String.split("%")
      |> List.first()
      |> String.to_integer()

    price - round(price * discount / 100)
  end

  defp price_per_hundred_gram(price, @gram_quantity) do
    round(price / 60)
  end
end
