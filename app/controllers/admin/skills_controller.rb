class Admin::SkillsController < Admin::BaseController

  before_action :load_category
  before_action :load_skill, only: [:show, :update]

  def index

  end

  def create
    @skill = @category.skills.new(skill_params)
    if @skill.save
      redirect_to [:admin, @category]
    end
  end
  
  def update
    @skill.update(skill_params)
    redirect_to [:admin, @category, @skill]
  end

  protected

  def load_category
    @category = Category.find params[:category_id]
  end

  def load_skill 
    @skill = @category.skills.find params[:id]
  end

  def skill_params
    params.require(:skill).permit(
      :name,
      outcomes_attributes: [
        :id, :text, :_destroy
      ]
    )
  end

end