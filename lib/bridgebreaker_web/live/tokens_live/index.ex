defmodule BridgebreakerWeb.TokensLive.Index do
  use BridgebreakerWeb, :live_view

  alias Bridgebreaker.Tokens
  alias Bridgebreaker.Chains

  @impl true
  def mount(_params, _session, socket) do
    start_timer(1000)
    {:ok, assign(socket, chains: [], eth: nil)}
  end

  @impl true
  def handle_info(:tick, socket) do
    {[eth], chains} = Enum.split_with(list_chains(), &(&1.name == "Ethereum"))
    eth = update_eth(eth)
    socket = assign(socket, chains: chains, eth: eth)
    {:noreply, socket}
  rescue
    _ ->
      {:noreply, socket}
  end

  defp start_timer(interval) do
    :timer.send_interval(interval, self(), :tick)
  end

  defp update_eth(eth) do
    {:ok, total_bridged_balance_via_accounting} = Tokens.get_crosschain_balances(eth)
    {:ok, bridge_asset_discrepancy} = Tokens.get_bridge_asset_discrepancy(eth, :crosschain)

    eth
    |> Map.put(:total_bridged_balance_via_accounting, total_bridged_balance_via_accounting)
    |> Map.put(:bridge_asset_discrepancy, bridge_asset_discrepancy)
  end

  defp list_chains do
    for chain <- Chains.list_chains() do
      {:ok, total_supply} = Tokens.get_total_supply(chain, :underlying)
      {:ok, underlying_balance} = Tokens.get_balance(chain, :underlying)

      {:ok, total_crosschain} = Tokens.get_total_supply(chain, :crosschain)
      {:ok, bridge_asset_discrepancy} = Tokens.get_bridge_asset_discrepancy(chain, :crosschain)

      chain
      |> Map.put(:underlying_total_supply, total_supply)
      |> Map.put(:bridge_asset_discrepancy, bridge_asset_discrepancy)
      |> Map.put(:crosschain_total_supply, total_crosschain)
      |> Map.put(:underlying_balance_of_contract, underlying_balance)
    end
  end
end
