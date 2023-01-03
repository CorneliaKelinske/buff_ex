defmodule BuffEx.HTTP do
  @moduledoc """
  Sends the get request to the website and pareses the response for further
  processing
  """

  @spec send_request_and_prep_response(String.t()) ::
          {:ok, Floki.html_tree()} | {:error, String.t()}
  def send_request_and_prep_response(url) do
    with {:ok, body} <- request(url) do
      Floki.parse_document(body)
    end
  end

  defp request(url) do
    Finch.build(
      :get,
      url
    )
    |> Finch.request(BuffEx.Finch)
    |> case do
      {:ok, %Finch.Response{status: 200, body: body}} -> {:ok, body}
      error -> {:error, inspect(error)}
    end
  end
end
