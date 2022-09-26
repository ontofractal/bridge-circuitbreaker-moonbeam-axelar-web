defmodule Bridgebreaker.Tokens do
  def get_total_supply(chain, :underlying) do
    n = name(chain, :underlying)
    {:ok, result} = call(chain, chain.underlyingAddress, abi(:bridged), n, :totalSupply)

    {:ok, result / 1.0e18}
  end

  def get_total_supply(chain, :crosschain) do
    n = name(chain, :crosschain)

    {:ok, result} = call(chain, chain.contractAddress, abi(:bridged), n, :totalSupply)
    {:ok, result / 1.0e18}
  end

  def get_bridge_asset_discrepancy(chain, :crosschain) do
    n = name(chain, :crosschain)

    call(chain, chain.contractAddress, abi(:crosschain), n, :bridgeAssetDiscrepancy)
  end

  def get_balance(chain, :underlying) do
    n = name(chain, :underlying)

    {:ok, a} = ExW3.Utils.hex_to_integer(chain.contractAddress)
    {:ok, v} = call(chain, chain.underlyingAddress, abi(:bridged), n, :balanceOf, [a])
    {:ok, to_ether(v)}
  end

  def get_crosschain_balances(chain) do
    n = name(chain, :crosschain)

    {:ok, v} =
      call(chain, chain.contractAddress, abi(:crosschain), n, :getBridgedUnderlyingBalance)

    {:ok, to_ether(v)}
  end

  def to_ether(v) do
    Float.round(v / 1.0e18, 6)
  end

  def name(chain, :underlying) do
    :"#{chain.name}_underlying_token"
  end

  def name(chain, :crosschain) do
    :"#{chain.name}_crosschain_token"
  end

  def call(chain, address, abi, name, fun, params \\ []) do
    ExW3.Contract.start_link()
    ExW3.Contract.register(name, abi: abi)
    ExW3.Contract.at(name, address)
    Application.put_env(:ethereumex, :url, chain.rpc)
    ExW3.Contract.call(name, fun, params)
  rescue
    _ -> {:ok, nil}
  end

  def abi(:bridged) do
    path = "ERC20Bridged.sol/ERC20Bridged.json"

    load_abi(path)
  end

  def abi(:crosschain) do
    load_abi("ERC20CrossChain.sol/ERC20CrossChain.json")
  end

  def load_abi(path) do
    Path.join(
      File.cwd!(),
      "../circuitbreaker/artifacts/contracts/#{path}"
    )
    |> File.read!()
    |> Jason.decode!()
    |> Map.get("abi")
    |> reformat_abi()
  end

  defp reformat_abi(abi) do
    abi
    |> Enum.map(&map_abi/1)
    |> Map.new()
  end

  defp map_abi(x) do
    case {x["name"], x["type"]} do
      {nil, "constructor"} -> {:constructor, x}
      {nil, "fallback"} -> {:fallback, x}
      {name, _} -> {name, x}
    end
  end
end
