defmodule BuffEx.Config do
  @moduledoc """
  Fetches the environmental variables from the config.exs file
  """

  @app :buff_ex

  @spec caseins :: [module()]
  def caseins do
    Application.fetch_env!(@app, :caseins)
  end
end
