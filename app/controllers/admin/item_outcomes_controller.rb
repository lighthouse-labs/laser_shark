class Admin::ItemOutcomesController < Admin::BaseController

  before_action :load_item_outcome, only: [:destroy]
  
  def create
    item_outcome = ItemOutcome.new(item_outcome_params)
    item_outcome.save
    redirect_to :back
  end

  def destroy
    @item_outcome.destroy
    redirect_to :back
  end

  protected
  
  def load_item_outcome
    @item_outcome = ItemOutcome.find params[:id]
  end

  def item_outcome_params
    params.require(:item_outcome).permit(:item_type, :item_id, :outcome_id)
  end

end