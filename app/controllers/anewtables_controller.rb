class AnewtablesController < ApplicationController
  # GET /anewtables
  # GET /anewtables.json
  def index
    @anewtables = Anewtable.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @anewtables }
    end
  end

  # GET /anewtables/1
  # GET /anewtables/1.json
  def show
    @anewtable = Anewtable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @anewtable }
    end
  end

  # GET /anewtables/new
  # GET /anewtables/new.json
  def new
    @anewtable = Anewtable.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @anewtable }
    end
  end

  # GET /anewtables/1/edit
  def edit
    @anewtable = Anewtable.find(params[:id])
  end

  # POST /anewtables
  # POST /anewtables.json
  def create
    @anewtable = Anewtable.new(params[:anewtable])

    respond_to do |format|
      if @anewtable.save
        format.html { redirect_to @anewtable, notice: 'Anewtable was successfully created.' }
        format.json { render json: @anewtable, status: :created, location: @anewtable }
      else
        format.html { render action: "new" }
        format.json { render json: @anewtable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /anewtables/1
  # PUT /anewtables/1.json
  def update
    @anewtable = Anewtable.find(params[:id])

    respond_to do |format|
      if @anewtable.update_attributes(params[:anewtable])
        format.html { redirect_to @anewtable, notice: 'Anewtable was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @anewtable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /anewtables/1
  # DELETE /anewtables/1.json
  def destroy
    @anewtable = Anewtable.find(params[:id])
    @anewtable.destroy

    respond_to do |format|
      format.html { redirect_to anewtables_url }
      format.json { head :no_content }
    end
  end
end
