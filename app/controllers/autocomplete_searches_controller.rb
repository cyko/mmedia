class AutocompleteSearchesController < ApplicationController
  respond_to :js

  def index
    @areas = Area.all
    respond_with(@areas)
  end

end
