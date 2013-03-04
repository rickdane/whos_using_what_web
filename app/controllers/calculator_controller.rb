class CalculatorController < ApplicationController

  layout 'searches'

  def new

    render :template => "searches/new"

  end


end
