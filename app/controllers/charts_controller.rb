class ChartsController < ApplicationController
  before_filter :select_authorized_transactions
  before_filter :select_span
  before_filter :include_category

  def pie
    @categories = @transactions.map(&:category).uniq

    @values = Hash.new 0
    @transactions.each do |t|
      @values[t.category_id] += params[:income] ? t.value : -t.value
    end

    @categories.delete_if {|category| @values[category.id] <= 0}

    total = @transactions.select {|t|
      @categories.include? t.category
    }.map(&:value).sum
    total = -total unless params[:income]

    @percentages = Hash.new 0
    @values.each_pair do |cat_id, value|
      @percentages[cat_id] = value * 100 / total if value > 0
    end if total > 0
  end
  end

  private
  def select_authorized_transactions
    @transactions = Transaction.accessible_by(current_ability, :index)
  end

  def select_span
    return if params[:all]

    @start_date =
      params[:s] && Date.parse(params[:s]) || Date.today.beginning_of_month
    @end_date =
      params[:e] && Date.parse(params[:e]) || Date.today.end_of_month

    @transactions = @transactions \
      .where('date BETWEEN ? AND ?', @start_date, @end_date)
  end

  def include_category
    @transactions = @transactions.includes :category
  end
end
