require_relative "ownable"

class Wallet
  include Ownable
  attr_reader :balance

  def initialize(owner)
    self.owner = owner
    @balance = 0
  end

  def deposit(amount)
    @balance += amount.to_i
  end

  def withdraw(amount)
    return nil unless @balance >= amount.to_i
    @balance -= amount.to_i
    amount.to_i
  end

end
