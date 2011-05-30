class Transaction < ActiveRecord::Base
  class NotZeroValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if value.to_f == 0
        record.errors[attribute] << "must not be zero"
      end
    end
  end

  Expense = 'expense'
  Income = 'income'

  belongs_to :category, :inverse_of => :transactions

  validates :date,
              :presence => true
  validates :category_name,
              :presence => true
  validates :value,
              :not_zero => true

  def human_value=(expr)
    @exp = expr
    v = Calc.evaluate(expr)
    v = nil unless v.kind_of? Numeric
    self.value = v
  end

  def human_value
    @exp || abs_value
  end

  def category_name=(name)
    self.category = Category.find_or_create_by_name(name)
  end

  def category_name
    category.name if category and category.valid?
  end

  def type
    if value and value.to_f < 0 then Expense
    else Income end
  end

  def abs_value
    v = self.value.to_f.abs
    v if v != 0
  end

  def expense
    if Expense == type
      value.abs
    else
      0.0
    end
  end

  def income
    if Income == type
      value
    else
      0.0
    end
  end
end
