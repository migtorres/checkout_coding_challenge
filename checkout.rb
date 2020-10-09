# This class scans items, applies promotion_rules and calculates total price
class Checkout
  def initialize(promotion_rules = [])
    @promotion_rules = promotion_rules
    @items = []
  end

  # Scan items in any orders
  def scan(item)
    @items << item
  end

  # calculates total price after discount
  def total
    full_price = @items.map { |i| i[:price] }.sum

    # first checks for single item discount
    @promotion_rules.select { |r| r[:type] == 'item' }.each do |rule|
      full_price -= item_discount(rule[:name], rule[:number], rule[:price])
    end

    # then calculates percentage discount
    @promotion_rules.select { |r| r[:type] == 'percentage' }.each do |rule|
      full_price -= percent_discount(full_price, rule[:minimum_value], rule[:percentage])
    end

    full_price.round(2)
  end

  private

  # calculates discount for items if you buy more than a minimum number
  def item_discount(name, minimum_number, new_price)
    discounted_items = @items.select { |i| i[:name] == name }
    discounted_items_number = discounted_items.count

    if discounted_items_number >= minimum_number
      price_difference = discounted_items[0][:price] - new_price
      price_difference * discounted_items_number
    else
      0
    end
  rescue ArgumentError
    0
  end

  # calculates a discount that consists in a percentage when total value is above a threshold
  def percent_discount(full_price, minimum_value, percentage)
    if full_price > minimum_value
      full_price * percentage / 100
    else
      0
    end
  rescue ArgumentError
    0
  end
end
