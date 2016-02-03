class Admin::LearningObjectivesController < ApplicationController
  before_action :set_model
  before_action :set_id, only: [:destroy, :edit]
  before_action :load_all

  helper_method :generic_create_path, :generic_delete_path, :generic_index_path

  def index
    render 'admin/learning_objectives/index'
  end

  def create
  end

  def show
  end

  def edit
  end

  def destroy
    @Model.destroy @id
    render 'admin/learning_objectives/index'
  end

  private

  def generic_create_path(obj)
    self.send("admin_#{controller_name}_path", obj)
  end

  def generic_delete_path(obj)
    self.send("admin_#{controller_name}_path", obj)
  end

  def generic_index_path
    self.send("admin_#{controller_name}_index_path")
  end

  def set_id
    @id = parameters[:id]
  end

  def load_all
    @data = @Model.all
  end

  def set_model
    @Model = controller_name.titlecase.constantize
  end

  def parameters
    params.permit(:id)
  end
end