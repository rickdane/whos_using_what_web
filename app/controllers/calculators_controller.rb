class CalculatorsController < ApplicationController

  layout 'calculator'

  def new

    render :template => "calculators/new"

  end


end
