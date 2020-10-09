require 'spec_helper'
require_relative '../checkout'

describe 'checkout' do
  describe '#total' do
    items = [{ code: '001', name: 'Lavender Heart', price: 9.25 },
             { code: '002', name: 'Personalised cufflinks', price: 45.00 },
             { code: '003', name: 'Kids T-shirt', price: 19.95 }]

    it 'gets 10 percent discount when spending more than 60' do
      promotion_rules = [{ type: 'percentage', minimum_value: 60, percentage: 10 }]
      co = Checkout.new(promotion_rules)
      co.scan(items[1])
      co.scan(items[1])
      expect(co.total).to eq(81)
    end

    it 'gets a discount for 2 lavender hearts' do
      promotion_rules = [{ type: 'item', name: 'Lavender Heart', number: 2, price: 8.50 }]
      co = Checkout.new(promotion_rules)
      co.scan(items[0])
      co.scan(items[0])
      co.scan(items[0])
      expect(co.total).to eq(25.5)
    end

    it 'gets a discount on both percentage and item lavender hearts' do
      promotion_rules = [{ type: 'percentage', minimum_value: 60, percentage: 10 },
                         { type: 'item', name: 'Lavender Heart', number: 2, price: 8.50 }]
      co = Checkout.new(promotion_rules)
      co.scan(items[0])
      co.scan(items[0])
      co.scan(items[0])
      co.scan(items[1])
      expect(co.total).to eq(63.45)
    end

    it 'handles empty promotion_rules with no discount' do
      promotion_rules = []
      co = Checkout.new(promotion_rules)
      co.scan(items[0])
      co.scan(items[0])
      co.scan(items[0])
      expect(co.total).to eq(27.75)
    end

    it 'handles no promotion_rules with no discount' do
      co = Checkout.new
      co.scan(items[0])
      co.scan(items[0])
      co.scan(items[0])
      expect(co.total).to eq(27.75)
    end

    it 'handles unknown promotional rule with no discount' do
      promotion_rules = [{ type: 'weird_discount', minimum_value: 60, percentage: 10 }]
      co = Checkout.new(promotion_rules)
      co.scan(items[0])
      co.scan(items[0])
      co.scan(items[0])
      expect(co.total).to eq(27.75)
    end

    it 'handles unknown percentage rule with no discount' do
      promotion_rules = [{ type: 'percentage', name: 60 }]
      co = Checkout.new(promotion_rules)
      co.scan(items[0])
      co.scan(items[0])
      co.scan(items[0])
      expect(co.total).to eq(27.75)
    end

    it 'handles unknown item rule with no discount' do
      promotion_rules = [{ type: 'item', minimum_value: 60 }]
      co = Checkout.new(promotion_rules)
      co.scan(items[0])
      co.scan(items[0])
      co.scan(items[0])
      expect(co.total).to eq(27.75)
    end

    it 'passes challenge test 1' do
      promotion_rules = [{ type: 'percentage', minimum_value: 60, percentage: 10 },
                         { type: 'item', name: 'Lavender Heart', number: 2, price: 8.50 }]
      co = Checkout.new(promotion_rules)
      co.scan(items[0])
      co.scan(items[1])
      co.scan(items[2])
      expect(co.total).to eq(66.78)
    end

    it 'passes challenge test 2' do
      promotion_rules = [{ type: 'percentage', minimum_value: 60, percentage: 10 },
                         { type: 'item', name: 'Lavender Heart', number: 2, price: 8.50 }]
      co = Checkout.new(promotion_rules)
      co.scan(items[0])
      co.scan(items[2])
      co.scan(items[0])
      expect(co.total).to eq(36.95)
    end

    it 'passes challenge test 3' do
      promotion_rules = [{ type: 'percentage', minimum_value: 60, percentage: 10 },
                         { type: 'item', name: 'Lavender Heart', number: 2, price: 8.50 }]
      co = Checkout.new(promotion_rules)
      co.scan(items[0])
      co.scan(items[1])
      co.scan(items[0])
      co.scan(items[2])
      expect(co.total).to eq(73.76)
    end
  end
end
