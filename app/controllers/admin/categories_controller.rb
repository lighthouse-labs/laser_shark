class Admin::CategoriesController < Admin::BaseController

  before_action :require_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to [:admin, :categories]
    else
      render :edit
    end
  end

  def show
  end

  def update
    if !@category.update(category_params)
      flash[:notice] = "Category not updated: #{@category.errors.full_messages[0]}"
    end
    redirect_to [:admin, :categories]
  end

  
  def destroy
    @category.destroy
    redirect_to [:admin, :categories]
  end

  private

  def require_category
    @category = Category.find params[:id]
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
