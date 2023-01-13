defmodule BuffExWeb.SupplementsLive.Index do
  use BuffExWeb, :live_view
  alias BuffEx.Supplements

  @impl true
  def mount(_params, _session, socket) do
    case Supplements.all_caseins() do
      {:ok, []} ->
        put_flash(socket, :error, "Something went wrong! Please reload the page!")

      {:ok, all_caseins} ->
        available_caseins = Supplements.all_available_caseins(all_caseins)
        cheapest_casein = Supplements.cheapest_casein(available_caseins)

        {:ok,
         assign(socket,
           available_caseins: available_caseins,
           cheapest_casein: cheapest_casein
         )}
    end
  end
end
