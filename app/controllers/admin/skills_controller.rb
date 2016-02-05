class Admin::SkillsController < ApplicationController

  before_action :load_parent
  before_action :require_skill, only: [:show, :edit, :update, :destroy]

  def index
    @skills = Skill.all
  end

  def edit
  end

  def create
    @skill = Skill.new(skill_params)
    if @skill.save
      @category.skills << @skill
      redirect_to [:admin, @category]
    else
      render :nothing => true, :status => 400
    end
  end

  def update
    if @skill.update(skill_params)
      redirect_to [:admin, @category]
    else
      render :nothing => true, :status => 400
    end
  end

  def show
    @parent = @skill
    @children = @skill.outcomes
  end

  def destroy
    @skill.destroy
    redirect_to [:admin, @category]
  end

  private

  def load_parent
    @category = Category.find params[:category_id]
  end

  def require_skill
    @skill = @category.skills.find params[:id]
  end

  def skill_params
    params.require(:skill).permit(:text)
  end
end