class SectionsController < ApplicationController

  before_action :load_public_sections
  before_action :load_section, only: [:show]

  protected

  def load_public_actions
    @sections = Section.public
  end

  def load_section
    @section = Section.public.find params[:id]
  end

end
