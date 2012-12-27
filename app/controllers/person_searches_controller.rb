class PersonSearchesController < ApplicationController
  # GET /person_searches
  # GET /person_searches.json
  def index
    @person_searches = PersonSearch.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @person_searches }
    end
  end

  # GET /person_searches/1
  # GET /person_searches/1.json
  def show
    @person_search = PersonSearch.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @person_search }
    end
  end

  # GET /person_searches/new
  # GET /person_searches/new.json
  def new
    @person_search = PersonSearch.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @person_search }
    end
  end

  # GET /person_searches/1/edit
  def edit
    @person_search = PersonSearch.find(params[:id])
  end

  # POST /person_searches
  # POST /person_searches.json
  def create
    @person_search = PersonSearch.new(params[:person_search])

    respond_to do |format|
      if @person_search.save
        format.html { redirect_to @person_search, notice: 'Person search was successfully created.' }
        format.json { render json: @person_search, status: :created, location: @person_search }
      else
        format.html { render action: "new" }
        format.json { render json: @person_search.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /person_searches/1
  # PUT /person_searches/1.json
  def update
    @person_search = PersonSearch.find(params[:id])

    respond_to do |format|
      if @person_search.update_attributes(params[:person_search])
        format.html { redirect_to @person_search, notice: 'Person search was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @person_search.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /person_searches/1
  # DELETE /person_searches/1.json
  def destroy
    @person_search = PersonSearch.find(params[:id])
    @person_search.destroy

    respond_to do |format|
      format.html { redirect_to person_searches_url }
      format.json { head :no_content }
    end
  end
end
