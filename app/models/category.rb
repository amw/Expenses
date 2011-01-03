class Category < ActiveRecord::Base
  has_many :transactions, :inverse_of => :category

  validates :name,
              :presence => true,
              :uniqueness => true
  validates :color,
              :format => { :with => /^#([a-f0-9]{3}|[a-f0-9]{6})$/ }

  before_validation :init_color

  def self.random_color
    '#' + (0..2).map { |i| (i*85 + rand(85)).to_s(16).rjust(2, '0') }.join
  end

  protected
  def init_color
    if color.nil?
      self.color = Category.random_color
    end
  end
end
