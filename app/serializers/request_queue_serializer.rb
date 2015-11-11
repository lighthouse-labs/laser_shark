class RequestQueueSerializer < ActiveModel::Serializer

  root false

  def attributes
    attrs = super
    attrs.tap do 
      attrs[:active_assistances] = active_assistances
      attrs[:requests] = requests
      attrs[:code_reviews] = code_reviews
      attrs[:all_students] = students
    end
  end

  protected

  def active_assistances
    object[:assistances].collect do |assistance|
      AssistanceSerializer.new(assistance).as_json
    end
  end

  def requests
    object[:requests].collect do |request|
      AssistanceRequestSerializer.new(request).as_json
    end
  end

  def code_reviews
    object[:code_reviews].collect do |code_review|
      CodeReviewSerializer.new(code_review).as_json
    end
  end

  def students
    object[:students].collect do |student|
      UserSerializer.new(student).as_json
    end
  end
end