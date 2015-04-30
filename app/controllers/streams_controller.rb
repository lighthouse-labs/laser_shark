class StreamsController < ApplicationController

  def index
    # ApplicationController#streams helper method used in index view
  end

  def show
    @stream = Stream.find(params[:id])
  end

end
