class CalculatorsController < ApplicationController

  layout 'searches'

  def new

    render :template => "calculators/new"

  end


end
