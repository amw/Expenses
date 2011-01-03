class TransactionsController < ApplicationController
  def index
    @transaction = Transaction.new
    @transactions = Transaction.order "date DESC"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transactions }
    end
  end

  # GET /transactions/1/edit
  def edit
    @transaction = Transaction.find(params[:id])
  end

  # POST /transactions
  # POST /transactions.xml
  def create
    @transaction = Transaction.new(params[:transaction])

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to(transactions_url, :notice => 'Transaction was successfully created.') }
        format.xml  { render :xml => @transaction, :status => :created, :location => @transaction }
      else
        format.html {
          @transactions = Transaction.order "date DESC"
          render :action => "index"
        }
        format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /transactions/1
  # PUT /transactions/1.xml
  def update
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        format.html { redirect_to(transactions_url, :notice => 'Transaction was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.xml
  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to(transactions_url) }
      format.xml  { head :ok }
    end
  end
end
