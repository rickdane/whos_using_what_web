class CalculatorsController < ApplicationController

  layout 'searches'

  def new

    puts "----> calculator"
    render :template => "searches/new"

  end


end
