class Admin::LearningObjectivesController < ApplicationController
  before_action :set_model
  before_action :set_name_model
  before_action :set_id, only: [:destroy, :edit, :show]
  before_action :set_instance, only: [:destroy, :edit, :show]
  before_action :load_all

  helper_method :generic_parent_path, :generic_show_path, :generic_update_path,
                :generic_delete_path, :generic_create_path, :heading
                # :generic_heading_update_path, :is_controller_action_show?

  def index
    render 'admin/learning_objectives/index'
  end

  def create
  end

  def show
    @data = @instance_model.children
    render 'admin/learning_objectives/index'
  end

  def update
  end

  def destroy
    @Model.destroy @id
    render 'admin/learning_objectives/index'
  end

  private

  def set_instance
    @instance_model = @Model.find @id
  end

  def is_controller_action_show?
    @action ||= parameters[:action] == 'show'
  end

  def heading
    if is_controller_action_show?
      @instance_model.text
    else
      controller_name.titlecase
    end
  end

  def generic_parent_path
    if parameters[:action] == 'index'
      self.send("admin_#{@model_parent_name.pluralize}_path")
    elsif controller_name == 'categories'
      self.send("admin_categories_path")
    else
      if @instance_model.my_parent
        self.send("admin_#{@model_parent_name.singularize}_path", @instance_model.my_parent)
      end
    end
  end

  def generic_show_path(obj)
    self.send("admin_#{@model_name}_path", obj)
  end

  def generic_delete_path(obj)
    self.send("admin_#{@model_name}_path", obj)
  end

  def generic_create_path
    self.send("admin_#{@model_name.pluralize}_path")
  end

  def generic_update_path(obj)
    self.send("admin_#{@model_name.singularize}_path", obj)
  end

  # def generic_heading_update_path(obj)
  #   self.send("admin_#{@Model.name.downcase.singularize}_path", obj)
  # end

  def set_id
    @id = parameters[:id]
  end

  def load_all
    @data = @Model.all
  end

  def set_model
    @Model = controller_name.titlecase.singularize.constantize
  end

  def set_name_model
    if is_controller_action_show?
      @model_name = @Model.child_name
    else
      @model_name = @Model.name.downcase
    end
    @model_parent_name = @Model.my_parent_name
  end

  def parameters
    params.permit(:id, :action)
  end
end