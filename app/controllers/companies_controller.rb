require_relative '../nosql/mongo_helper'

class CompaniesController < ApplicationController

  before_filter :initial_filter

  def initialize

    super

    @mongo_client = MongoHelper.get_mongo_connection

  end

  #todo make this as mix-in method for use in other controllers
  def initial_filter
    @cur_view_user = Hash.new

    logged_in = session[:logged_in]

    if  logged_in == nil
      logged_in = false
      #todo figure out how to use template here
    elsif logged_in
      #todo remove any sensitive data from view layer user object after clone
      @cur_view_user["user"] = self.current_user.clone
    end
    @cur_view_user["logged_in"] = logged_in

  end


  layout "companies"
  # GET /companies
  # GET /companies.json
  def index

    @coll = @mongo_client['test']


=begin

    @companies = Company.all

    @current_user ||= User.find_by_id(session[:user_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @companies }
    end
=end
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    @company = Company.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @company }
    end
  end

  # GET /companies/new
  # GET /companies/new.json
  def new
    @company = Company.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @company }
    end
  end

  # GET /companies/1/edit
  def edit
    @company = Company.find(params[:id])
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(params[:company])

    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
        format.json { render json: @company, status: :created, location: @company }
      else
        format.html { render action: "new" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end


  # PUT /companies/1
  # PUT /companies/1.json
  def update
    @company = Company.find(params[:id])

    respond_to do |format|
      if @company.update_attributes(params[:company])
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company = Company.find(params[:id])
    @company.destroy

    respond_to do |format|
      format.html { redirect_to companies_url }
      format.json { head :no_content }
    end
  end
end
