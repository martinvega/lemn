class PartnersController < ApplicationController

  # GET /partners
  # GET /partners.json
  def index
    @title = t('view.partners.index_title')
    @partners = Partner.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @partners }
    end
  end

  # GET /partners/1
  # GET /partners/1.json
  def show
    @title = t('view.partners.show_title')
    @partner = Partner.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @partner }
    end
  end

  # GET /partners/new
  # GET /partners/new.json
  def new
    @title = t('view.partners.new_title')
    @partner = Partner.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @partner }
    end
  end

  # GET /partners/1/edit
  def edit
    @title = t('view.partners.edit_title')
    @partner = Partner.find(params[:id])
  end

  # POST /partners
  # POST /partners.json
  def create
    @title = t('view.partners.new_title')
    @partner = Partner.new(params[:partner])

    respond_to do |format|
      if @partner.save
        format.html { redirect_to @partner, :notice => t('view.partners.correctly_created') }
        format.json { render :json => @partner, :status => :created, :location => @partner }
      else
        format.html { render :action => 'new' }
        format.json { render :json => @partner.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /partners/1
  # PUT /partners/1.json
  def update
    @title = t('view.partners.edit_title')
    @partner = Partner.find(params[:id])

    respond_to do |format|
      if @partner.update_attributes(params[:partner])
        format.html { redirect_to @partner, :notice => t('view.partners.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render :action => 'edit' }
        format.json { render :json => @partner.errors, :status => :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_partner_url(@partner), :alert => t('view.partners.stale_object_error')
  end

  # DELETE /partners/1
  # DELETE /partners/1.json
  def destroy
    @partner = Partner.find(params[:id])
    @partner.destroy

    respond_to do |format|
      format.html { redirect_to partners_url }
      format.json { head :ok }
    end
  end
end
