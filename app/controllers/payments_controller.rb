class PaymentsController < ApplicationController
  require 'will_paginate/array'
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource

  # GET /payments
  # GET /payments.json
  def index
    @user = current_user.user
    @title = t('view.payments.index_title')
    @searchable = false

    if params[:partner_id]
      @payments = Payment.by_partner(params[:partner_id]).page(params[:page])
    elsif params[:expired]
      @payments = Payment.expired.paginate(:page => params[:page], :per_page => 12)
    elsif params[:next_to_expire]
      @payments = Payment.next_to_expire.paginate(:page => params[:page], :per_page => 12)
    else
      @payments = Payment.filtered_list(params[:q]).page(params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @payments }
    end
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
    @title = t('view.payments.show_title')
    @payment = Payment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @payment }
    end
  end

  # GET /payments/new
  # GET /payments/new.json
  def new
    @title = t('view.payments.new_title')
    @payment = Payment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @payment }
    end
  end

  # GET /payments/1/edit
  def edit
    @title = t('view.payments.edit_title')
    @payment = Payment.find(params[:id])
  end

  # POST /payments
  # POST /payments.json
  def create
    @title = t('view.payments.new_title')
    @payment = Payment.new(params[:payment])
    @payment.user = current_user

    respond_to do |format|
      if @payment.save
        format.html { redirect_to @payment, :notice => t('view.payments.correctly_created') }
        format.json { render :json => @payment, :status => :created, :location => @payment }
      else
        format.html { render :action => 'new' }
        format.json { render :json => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /payments/1
  # PUT /payments/1.json
  def update
    @title = t('view.payments.edit_title')
    @payment = Payment.find(params[:id])

    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        format.html { redirect_to @payment, :notice => t('view.payments.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render :action => 'edit' }
        format.json { render :json => @payment.errors, :status => :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_payment_url(@payment), :alert => t('view.payments.stale_object_error')
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to payments_url }
      format.json { head :ok }
    end
  end
end
