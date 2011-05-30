class TransactionsController < ApplicationController
  inherit_resources
  respond_to :html
  actions :all, :except => :show

  load_and_authorize_resource

  def index
    @transaction = Transaction.new
    if Time.now.hour > 5
      @transaction.date = Date.today
    else
      @transaction.date = Date.today - 1.day
    end

    init_index
    index!
  end

  def create
    update_expense_value

    create! do |success,failure|
      failure.html do
        init_index
        render :index
      end
    end
  end

  def update
    update_expense_value
    update!
  end

  private
  def update_expense_value
    if params[:commit] != '+'
      v = @transaction.value
      @transaction.value = -v if v
    end
  end

  def init_index
    @transactions = Transaction.order "date DESC, id DESC"
    @categories = Category.all.select {|c| not c.transactions.empty?}
  end
end
