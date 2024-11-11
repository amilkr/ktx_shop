defmodule KtxShop.Products do
  @moduledoc """
  Products Context
  """

  @table __MODULE__

  alias KtxShop.Product

  @doc """
  Fetches products from the config and store them in an ets
  """
  @spec seed() :: :ok
  def seed() do
    # Fetch and parse products from the config
    products = Application.fetch_env!(:ktx_shop, :products)
    ets_records = Enum.map(products, &{&1.code, struct(Product, &1)})

    # Create the ets table and store the products
    @table = :ets.new(@table, [:named_table, :public, read_concurrency: true])
    true = :ets.insert(@table, ets_records)

    :ok
  end

  @doc """
  Returns a boolean indicating if the give product_code exists in the system
  """
  @spec exists?(String.t()) :: boolean()
  def exists?(product_code), do: :ets.member(@table, product_code)

  @doc """
  Returns the product for the given product code.
  If the code doesn't match to any product, it raises.
  """
  @spec get!(String.t()) :: Product.t()
  def get!(code) do
    [{_code, product}] = :ets.lookup(@table, code)
    product
  end
end
