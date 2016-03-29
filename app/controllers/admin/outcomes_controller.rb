class Admin::OutcomesController < Admin::BaseController

  before_action :require_outcome, except: [:index, :new, :create]
  before_action :require_category, except: [:index, :new]

  def index
    if params[:outcome_text]
      @outcomes = Outcome.search(params[:outcome_text])
    else
      @outcomes = Outcome.all
    end
  end

  def show
    @activity_outcomes = @outcome.activity_outcomes.includes(:activity)
  end

  def create
    @outcome = Outcome.new(outcome_params)
    @outcome.category = @category
    if !@outcome.save
      errors = build_error_messages(@outcome).join(" - ")
      flash[:notice] = "Outcome not created: - #{errors}"
    end
    redirect_to [:admin, @category]
  end

  def update
    if !@outcome.update(outcome_params)
      errors = build_error_messages(@outcome).join(" - ")
      flash[:notice] = "Outcome not updated: - #{errors}"
    end
    redirect_to :back
  end

  def destroy
    @outcome.destroy
    redirect_to [:admin, @category, @skill]
  end

  def autocomplete
    @activities = (Activity.search(params[:term]) - @outcome.activities)
    render json: OutcomeAutocompleteSerializer.new(activities: @activities).activities.as_json, root: false
  end

  private

  def require_outcome
    @outcome = Outcome.includes(:skills).find(params[:id])
  end

  def require_category
    @category = Category.find(params[:category_id])
  end

  def outcome_params
    params.require(:outcome).permit(:text, skills_attributes: [:id, :text, :_destroy])
  end

  def build_error_messages(outcome)
    errors = []
    errors << 'Outcome text is already taken' unless outcome.errors[:text].empty?
    skill_errors = outcome.skills.select { |s| !s.valid? }
    unless skill_errors.empty?
      skill_errors.each do |skill|
        errors << "Skill '#{skill.text}' is already assigned to another outcome"
      end
    end
    errors
  end

end