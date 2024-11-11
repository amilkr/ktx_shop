# KtxShop

This a simple Elixir application created as part of a technical interview.

### Requirements

  * erlang 26.2.5
  * elixir 1.16.3-otp-26
  
For those using [asdf](https://asdf-vm.com/), you will find a `.tool-versions` file at the root of the project.

### Running Tests

`$ mix deps.get`

`$ mix test --cover`

```
$ mix test --cover
Cover compiling modules ...
...
Finished in 0.04 seconds (0.00s async, 0.04s sync)
3 tests, 0 failures

Randomized with seed 825471

Generating cover results ...

Percentage | Module
-----------|--------------------------
   100.00% | KtxShop
   100.00% | KtxShop.Cart
   100.00% | KtxShop.Carts
   100.00% | KtxShop.Discounts
   100.00% | KtxShop.Product
   100.00% | KtxShop.Products
-----------|--------------------------
   100.00% | Total

Generated HTML coverage results in "cover" directory
```

### Run and use the application locally

Fetch deps

`$ mix deps.get`

Start the application

`$ iex -S mix`

Add some products to a cart

```elixir
iex(1)> cart = KtxShop.add_products_to_cart(["SR1", "GR1"])
%KtxShop.Cart{
  subtotal: Decimal.new("8.11"), # price before discounts
  total: Decimal.new("8.11"), # price after discounts
  items: %{"GR1" => 1, "SR1" => 1}
}

iex(2)> cart = KtxShop.add_products_to_cart(cart, ["GR1", "CF1"])
%KtxShop.Cart{
  subtotal: Decimal.new("22.45"), # price before discounts
  total: Decimal.new("19.34"), # price after discounts
  items: %{"CF1" => 1, "GR1" => 2, "SR1" => 1}
}
```

### Using the application

The application API is defined in the `KtxShop` module.\
There're 2 functions there:
  * `add_products_to_cart/2`

    It's the function to use and test the system. It allows adding products to a cart and calculates the total price. 
    
    Check `KtxShop.add_products_to_cart/2` doc for examples and details

  * `seed/0` 
   
    It fetches products from the config and add them to an ets table.
  
    The `.iex.exs` file calls this function, so that each time the application is started with `iex -S mix` the function is executed. 

### Implementation Notes

* __About tests__

  I only wrote tests for the application API, i.e. for the `KtxShop` module functions. But in a real-life application I would write tests for all the other modules too. I achieved 100% of coverage

 
* __About products__

  `KtxShop.seed/0` creates an ets table and inserts there the products defined in the config. This way, the carts don't need to keep all the products data into their structs, but only the product codes. Consuming less memory and, in the future, we could update the products in the ets table (price, name, discount_code) impacting all the carts in the system

* __About flexibility to update prices__
  
  As mentioned above, we could update product prices and discounts directly in the ets table (the function name would be something like `KtxShop.Products.update_product/2`). We could also add new products (`KtxShop.Products.create_product/1`). 
  
  To recalculate carts' prices there're different approaches we could follow. For example: in the current implementation, after adding a product to a cart, the cart prices are recalculated by fetching all the cart's products from the ets. So, if a product price or product discount was updated in the ets, the cart prices would be updated accordingly 

 