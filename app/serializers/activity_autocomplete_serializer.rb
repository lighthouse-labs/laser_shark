class ActivityAutocompleteSerializer < ActiveModel::Serializer

  root false

  def attributes
    attrs = super
    attrs.tap do 
      attrs[:outcomes] = outcomes
    end
  end

  def outcomes
    object[:outcomes].collect do |activity|
      OutcomeSerializer.new(activity).as_json
    end
  end

end