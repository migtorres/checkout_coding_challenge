# Shop Test

Ruby app for a checkout app that reads promotion and scans items calculating a total price

## Install

You should have installed Ruby (if possible using RVM) and if you do not have bundler install you should install it globally typing:


```
gem install bundler
```

Having bundler install you will just need to install the gems:

```
bundle install
```

## Running

### Checkout Class

`Checkout.new(promotional_rules)` creates a chackout object initialised with the `promotion_rules` parameter

`promotion_rules` consists in an array of hashes and each hash is a given rule.

Currently `Checkout` accepts 2 types of promotions:

- `item`:

When someone buys more than a number of items gets a lower price for every single item. The hash needs to have the following keys:

* `type`: Type of discount. In this case 'item' 
* `name`: Name of the item subject to discount 
* `number`: Number of items needed to have a discount
* `price`: Price per item since the discount is applied

Example: `{ type: 'item', name: 'Lavender Heart', number: 2, price: 8.50 }`

- `percentage`:

When the total cost exceeds a value it is given a percentual discount. The hash needs to have the following keys:

* `type`: Type of discount. In this case 'percentage'
* `minimum_value`: Threshold above which a discount is applied
* `percentage`: Percentage of discount

Example: `{ type: 'percentage', minimum_value: 60, percentage: 10 }`

### .scan

Scans items. The items should be hashes as the following example:

`{ code: '001', name: 'Lavender Heart', price: 9.25 }`


## Total

Calculates the total price to pay for all items scanned and with discounts applied


## Tests

We are using rspec for testing. The tests are in the [spec/](spec directory).

To run the tests you should:
```
bundle exec rspec spec
```

## Future developments

Currently the code handles wrong promotions as no-discounts. It could be interesting to improve the error handling and provide error messages instead.
