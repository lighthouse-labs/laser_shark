class ActivityMessagesController < ApplicationController

  include CourseCalendar # concern

  before_action :require_activity
  before_action :teacher_required
  before_action :require_message, only: [:edit, :update, :destroy]

  def new
    @message = @activity.messages.new(
      cohort: @cohort, 
      kind: ActivityMessage::KINDS.first,
      for_students: true
    )
  end

  def edit
    
  end

  def create
    @message = @activity.messages.new(message_params.merge({
      user: current_user,
      day: @activity.day
    }))
    @message.body << "\n" + day_activity_url(@activity.day, @activity)
    if @message.save
      notice = "Message Created."
      notice << " Students notified" if @message.for_students?
      redirect_to day_activity_path(@activity.day, @activity), notice: notice
    else
      @message.body.gsub!("\n#{day_activity_url(@activity.day, @activity)}", "")
      render :new
    end
  end

  def update
    
    if @message.update(message_params)
      notice = 'Message Updated.' 
      notice << ' E-mails do not get resent!' if @message.for_students? 
      redirect_to day_activity_path(@activity.day, @activity), notice: notice
    else
      render :new
    end
  end

  def destroy
    if @message.destroy
      redirect_to day_activity_path(@activity.day, @activity), notice: "Message removed"
    else
      redirect_to day_activity_path(@activity.day, @activity), alert: "Couldn't do it!"
    end
  end

  private

  def message_params
    params.require(:activity_message).permit(
      :subject, 
      :kind, 
      :cohort_id, 
      :subject,
      :body,
      :teacher_notes,
      :for_students
    )
  end

  def teacher_required
    redirect_to(day_activity_path(@day, @activity), alert: 'Not allowed') unless teacher?
  end

  def require_message
    @message = @activity.messages.find params[:id]
  end

  def require_activity
    @activity = Activity.find(params[:activity_id])
  end

end
