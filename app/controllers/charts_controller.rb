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

  def trends
    @months = {}
    date = @start_date
    id = 0
    while date < @end_date
      @months[l(date, format: '%Y-%m')] = {
        id: id,
        name: l(date, format: '%b')
      }
      id += 1
      date += 1.month
    end

    @values = Hash.new { |h, k| h[k] = Array.new @months.size, 0 }
    @categories_totals = Hash.new 0
    @transactions.each do |t|
      month = l(t.date, format: '%Y-%m')
      @values[t.category_id][@months[month][:id]] -= t.value
      @categories_totals[t.category_id] -= t.value
    end

    # round each sum
    @values.each_pair do |cat_id,values|
      values.each_with_index do |value,idx|
        @values[cat_id][idx] = value.round
      end
    end

    @categories = @transactions.map(&:category).uniq.sort_by do |c|
      -@categories_totals[c.id]
    end
  end

  private
  def select_authorized_transactions
    @transactions = Transaction.accessible_by(current_ability, :index)
  end

  def select_span
    return if params[:all]

    @start_date =
      params[:s] && Date.parse(params[:s]) || default_start_date
    @end_date =
      params[:e] && Date.parse(params[:e]) || default_end_date

    @transactions = @transactions \
      .where('date BETWEEN ? AND ?', @start_date, @end_date)
  end

  def include_category
    @transactions = @transactions.includes :category
  end

  def default_start_date
    case action_name
    when 'pie' then Date.today.beginning_of_month
    when 'trends' then Date.today.beginning_of_month - 5.months
    end
  end

  def default_end_date
    Date.today.end_of_month
  end
end
