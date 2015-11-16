require 'twilio-ruby'
require 'dotenv'
require_relative 'message'
Dotenv.load


class Order 

  include Message

  attr_reader :total, :menu, :basket

  def initialize(menu = Menu.new)
    @menu = menu
    @basket = {}
    @total = 0.0
  end

  def check_dishes
    list_of_dishes = ''
    menu.dishes_available.each do |dish, price|
      list_of_dishes += "#{dish} £#{price}\n"
    end
    list_of_dishes
  end

  def add_item(dish, quantity = 1)
    fail 'That item is not on the menu' unless menu.dishes_available.key?(dish)
    check_basket_and_add(dish, quantity)
    price = quantity * menu.dishes_available[dish].round(2)
    @total += price.round(2)
  end

  def remove_item(dish, quantity = 1)
    fail 'Item was not in the basket' unless basket.include?(dish)
    fail 'You do not have that quantity of the item in the basket' if quantity > basket[dish]
    quantity_check_and_remove(dish, quantity)
    price = quantity * menu.dishes_available[dish].round(2)
    @total -= price.round(2)
  end

  def total_price_verified?
    basket_total = 0.0
    basket.each do |dish, quantity|
      basket_total += quantity * menu.dishes_available[dish].round(2)
    end
    basket_total.round(2) == total ? true : false
  end

  def place_order
    fail 'Basket is empty' if basket.empty?
    fail 'The total price has been miscalculated' unless total_price_verified?
    send_message
    "Thank you for your order. You will receive text confirmation shortly"
  end

  private 

  attr_writer :total

  def check_basket_and_add(dish, quantity)
    basket.key?(dish) ? basket[dish] += quantity : basket[dish] = quantity
  end

  def quantity_check_and_remove(dish, quantity)
    basket[dish] == quantity ? basket.delete(dish) : basket[dish] -= quantity
  end

end