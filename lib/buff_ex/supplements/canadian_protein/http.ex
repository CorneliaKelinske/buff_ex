defmodule BuffEx.Supplements.CanadianProtein.HTTP do
  @moduledoc """
  Sends the get request to the website and pareses the response for further
  processing
  """

  alias BuffEx.Support.HTTPSandbox

  @defaults_opts [
    sandbox?: Mix.env() === :test
  ]

  @spec send_request_and_prep_response(String.t(), keyword()) ::
          {:ok, Floki.html_tree()} | {:error, String.t()}
  def send_request_and_prep_response(url, opts \\ []) do
    with {:ok, body} <- request(url, opts) do
      Floki.parse_document(body)
    end
  end

  defp request(url, opts) do
    opts = Keyword.merge(@defaults_opts, opts)

    if opts[:sandbox?] do
      HTTPSandbox.get_response(url, %{}, [])
    else
      Finch.build(:get, url)
      |> Finch.request(BuffEx.Finch)
      |> case do
        {:ok, %Finch.Response{status: 200, body: body}} ->
          {:ok, body}

        error ->
          {:error,
           ErrorMessage.expectation_failed("Something went wrong", %{error: inspect(error)})}
      end
    end
  end
end
