class Category < ActiveRecord::Base
  DefaultColors = ['#fa7b71', '#f6b75c', '#f1de62', '#c0da60', '#71b5fc',
                   '#cca3de', '#b8b7b8']

  has_many :transactions, :inverse_of => :category

  validates :name,
              :presence => true,
              :uniqueness => true
  validates :color,
              :format => { :with => /^#([a-f0-9]{3}|[a-f0-9]{6})$/ }

  before_validation :init_color

  def expenses
    @expenses ||= transactions.all.sum { |t|
      if t.type == Transaction::Expense then t.value.abs
      else 0 end
    }
  end

  def self.random_color
    '#' +
      (0..2).sort_by { rand } \
      .map { |i| (i*85 + rand(85)).to_s(16).rjust(2, '0') } \
      .join
  end

  def self.random_pallete_color
    colorUsage = {}
    DefaultColors.each { |color| colorUsage[color] = 0 }
    self.all.each { |category|
      colorUsage[category.color] += 1 if colorUsage.has_key? category.color
    }
    timesUsed = colorUsage.values.sort.first
    colorUsage.select {|color,usage| usage == timesUsed}.keys.sample
  end

  protected
  def init_color
    if color.nil?
      self.color = Category.random_pallete_color
    end
  end
end
