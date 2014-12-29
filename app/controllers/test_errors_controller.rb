class TestErrorsController < ApplicationController

  # To test 500 error notifications on production
  def create
    hello.error
  end

end
