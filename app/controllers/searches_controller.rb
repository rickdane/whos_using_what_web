class SearchesController < ApplicationController

  before_filter :initial_filter

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

  def get_people_for_company


  end


  # GET /tests/new
  # GET /tests/new.json
  def new
    @search = Search.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @search }
    end
  end

  # POST /tests
  # POST /tests.json
  def search
    @search = Search.new(params[:search])
    @results = Array.new
    
    #mock results
    @results.push("some company")
    @results.push("another company")
    
    puts "search query is: " + @search.name


    render 'searches/search_results'
  end

end
