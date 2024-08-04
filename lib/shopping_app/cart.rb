require_relative "item_manager"
require_relative "ownable"

class Cart
  include ItemManager
  include Ownable

  attr_accessor :owner

  def initialize(owner)
    self.owner = owner
    @items = []
  end

  def items
    # Cartにとってのitemsは自身の@itemsとしたいため、ItemManagerのitemsメソッドをオーバーライドします。
    # CartインスタンスがItemインスタンスを持つときは、オーナー権限の移譲をさせることなく、自身の@itemsに格納(Cart#add)するだけだからです。
    @items
  end

  def add(item)
    @items << item
  end

  def total_amount
    # total_amountメソッドは、カート内の全アイテムの合計金額を計算
    @items.sum(&:price)
  end

  def check_out
    return if owner.wallet.balance < total_amount
    # check_outメソッド、カートのオーナーのウォレットの残高がカート内のアイテムの合計金額以上か確認。十分な残高がない場合、処理中断。

    @items.each do |item|
      owner.wallet.withdraw(item.price)
      # カートのオーナーのウォレットからアイテムの価格分を引き出す。
      item.owner.wallet.deposit(item.price)
      # アイテムの元のオーナーのウォレットにアイテムの価格分を入金。
      item.owner = owner
      # アイテムのオーナーをカートのオーナーに変更。
    end
    @items.clear
    
  # ## 要件
  #   - カートの中身（Cart#items）のすべてのアイテムの購入金額が、カートのオーナーのウォレットからアイテムのオーナーのウォレットに移されること。
  #   - カートの中身（Cart#items）のすべてのアイテムのオーナー権限が、カートのオーナーに移されること。
  #   - カートの中身（Cart#items）が空になること。

  # ## ヒント
  #   - カートのオーナーのウォレット ==> self.owner.wallet
  #   - アイテムのオーナーのウォレット ==> item.owner.wallet
  #   - お金が移されるということ ==> (？)のウォレットからその分を引き出して、(？)のウォレットにその分を入金するということ
  #   - アイテムのオーナー権限がカートのオーナーに移されること ==> オーナーの書き換え(item.owner = ?)
  end

end
