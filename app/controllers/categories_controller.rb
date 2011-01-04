class CategoriesController < ApplicationController
  # GET /categories
  # GET /categories.xml
  def index
    @categories = Category.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html {
        init_index
        render "transactions/index"
      }
      format.xml  { render :xml => @category }
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to(@category, :notice => 'Category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html {
          init_index
          render 'transactions/index'
        }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def init_index
    @transactions = @category.transactions.order "date DESC, id DESC"
    @transaction = Transaction.new
    @transaction.date = Date.today
    @transaction.category_name = @category.name
    @categories = Category.all.select {|c| not c.transactions.empty?}
  end
end
