class AssistancesController < ApplicationController
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource

  # GET /assistances
  # GET /assistances.json
  def index
    @title = t('view.assistances.index_title')
    @searchable = false

    if params[:partner_id]
      @assistances = Assistance.by_partner(params[:partner_id]).page(params[:page])
    else
      @assistances = Assistance.filtered_list(params[:q]).page(params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @assistances }
    end
  end

  # GET /assistances/1
  # GET /assistances/1.json
  def show
    @title = t('view.assistances.show_title')
    @assistance = Assistance.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @assistance }
    end
  end

  # GET /assistances/new
  # GET /assistances/new.json
  def new
    @title = t('view.assistances.new_title')
    @assistance = Assistance.new
    @partner = Partner.new
    @assistance.partner = @partner

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @assistance }
    end
  end

  # GET /assistances/1/edit
  def edit
    @title = t('view.assistances.edit_title')
    @assistance = Assistance.find(params[:id])
  end

  # POST /assistances
  # POST /assistances.json
  def create
    @title = t('view.assistances.new_title')
    @assistance = Assistance.new(params[:assistance])
    @assistance.user = current_user

    respond_to do |format|
      if @assistance.save
        format.html { redirect_to @assistance, :notice => t('view.assistances.correctly_created') }
        format.json { render :json => @assistance, :status => :created, :location => @assistance }
      else
        format.html { render :action => 'new' }
        format.json { render :json => @assistance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /assistances/1
  # PUT /assistances/1.json
  def update
    @title = t('view.assistances.edit_title')
    @assistance = Assistance.find(params[:id])

    respond_to do |format|
      if @assistance.update_attributes(params[:assistance])
        format.html { redirect_to @assistance, :notice => t('view.assistances.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render :action => 'edit' }
        format.json { render :json => @assistance.errors, :status => :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_assistance_url(@assistance), :alert => t('view.assistances.stale_object_error')
  end

  # DELETE /assistances/1
  # DELETE /assistances/1.json
  def destroy
    @assistance = Assistance.find(params[:id])
    @assistance.destroy

    respond_to do |format|
      format.html { redirect_to assistances_url }
      format.json { head :ok }
    end
  end
end
