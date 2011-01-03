class Transaction < ActiveRecord::Base
  class NotZeroValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors[attribute] << "must not be zero" unless value.to_f != 0
    end
  end

  Expense = 'expense'
  Income = 'income'

  belongs_to :category, :inverse_of => :transactions

  validates :date,
              :presence => true
  validates :category_name,
              :presence => true
  validates :type,
              :inclusion => { :in => [Expense,Income] }
  validates :value,
              :numericality => true,
              :not_zero => true

  def category_name=(name)
    self.category = Category.find_or_create_by_name(name)
  end

  def category_name
    category.name if category and category.valid?
  end

  def type=(new_type)
    if value.present? and type != new_type
      write_attribute(:value, -read_attribute(:value).to_f)
    end
  end

  def type
    v = read_attribute :value
    if v and v.to_f < 0 then Expense
    else Income end
  end

  def value=(new_value)
    new_value = - new_value.to_f if type == Expense
    write_attribute(:value, new_value)
  end

  def value
    v = read_attribute(:value).to_f.abs
    v if v != 0
  end
end
