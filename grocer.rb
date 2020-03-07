require 'pp'
require 'pry'

CLEARNCE_DISCOUNT_RATE = 0.20
SPECIAL_DISCOUNT_RATE = 0.10

def find_item_by_name_in_collection(name, collection)
  # Implement me first!
  #
  # Consult README for inputs and outputs
  row_index = 0 
  while row_index < collection.count do 
    item = collection[row_index]
    return item if name === collection[row_index][:item]
    row_index += 1
  end
  
  nil
  
  # fancy
  # get the first item matching `name`
  # collection.select { |k| k[:item] == name }.first
end

def consolidate_cart(cart)
  new_cart = []
  
  row_index = 0 
  while row_index < cart.count do
    item_name = cart[row_index][:item]
    found_item = find_item_by_name_in_collection(item_name, new_cart)
    # pp found_item
    if found_item
      found_item[:count] += 1
    else 
      cart[row_index][:count] = 1
      new_cart << cart[row_index]
    end
    row_index += 1
  end
  new_cart
end

def apply_coupons(cart, coupons)
  # Consult README for inputs and outputs
  #
  
  i = 0 
  while i < coupons.count do
    # get coupon item from cart
    coupon = coupons[i]
    item_with_coupon = find_item_by_name_in_collection(coupon[:item], cart)
    item_is_in_basket = !!item_with_coupon
    item_count_meets_quota = item_is_in_basket && item_with_coupon[:count] >= coupon[:num]
    
    if item_is_in_basket && item_count_meets_quota
      # create new item with coupon hash
      item_with_coupon[:count] -= coupon[:num]
      new_item = {
        :item   => coupon[:item] + ' W/COUPON',
        :price  => (coupon[:cost].to_f * 1.0 / coupon[:num]).round(2),
        :count  => coupon[:num]
      }
      new_item[:clearance] = item_with_coupon[:clearance]
      cart << new_item
    end
    
    i += 1
  end
  cart
end

def apply_clearance(cart)
  # Consult README for inputs and outputs
  i = 0 
  while i < cart.count do
    item = cart[i]
    if item[:clearance]
      discount_in_dollars = (item[:price] * CLEARNCE_DISCOUNT_RATE).round(2)
      item[:price] -= discount_in_dollars
    end
    i += 1
  end
  cart
end

def checkout(cart, coupons)
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers
  
  consolidated_cart = consolidate_cart(cart)
  cart_with_coupons = apply_coupons(cart, coupons)
  cart_with_clearance = apply_clearance(cart)
  
  sub_total = cart_with_clearance.map{|y| y[:price] * y[:count]}.reduce(:+)
  pp sub_total
  
  total = (sub_total >= 100.00) ? (sub_total - sub_total * SPECIAL_DISCOUNT_RATE) : sub_total
end
