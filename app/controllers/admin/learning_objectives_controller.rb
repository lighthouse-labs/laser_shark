class Admin::LearningObjectivesController < ApplicationController
  before_action :set_model
  before_action :set_name_model
  before_action :set_id, only: [:destroy, :edit, :show]
  before_action :set_instance, only: [:destroy, :edit, :show]
  before_action :load_all

  helper_method :generic_parent_show_path, :generic_show_path,
                :generic_delete_path, :generic_index_path, :heading

  def index
    render 'admin/learning_objectives/index'
  end

  def create
  end

  def show
    @data = @instance_model.children
    render 'admin/learning_objectives/index'
  end

  def edit
  end

  def destroy
    @Model.destroy @id
    render 'admin/learning_objectives/index'
  end

  private

  def set_instance
    @instance_model = @Model.find @id
  end

  def heading
    if parameters[:action] == 'show'
      @instance_model.text
    else
      controller_name.titlecase
    end
  end

  def generic_parent_show_path
    if params[:action] == 'index'
      self.send("admin_#{@model_parent_name}_index_path")
    elsif controller_name == 'category'
      self.send("admin_category_index_path")
    else
      self.send("admin_#{@model_parent_name}_path", @instance_model.my_parent)
    end
  end

  def generic_show_path(obj)
    self.send("admin_#{@model_name}_path", obj)
  end

  def generic_delete_path(obj)
    self.send("admin_#{@model_name}_path", obj)
  end

  def generic_index_path
    self.send("admin_#{@model_name}_index_path")
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

  def set_name_model
    if parameters[:action] == 'show'
      @model_name = @Model.child_name
    else
      @model_name = @Model.name.downcase
    end
    @model_parent_name = @Model.parental_name
  end

  def parameters
    params.permit(:id, :action)
  end
end