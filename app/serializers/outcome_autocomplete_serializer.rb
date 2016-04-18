class OutcomeAutocompleteSerializer < ActiveModel::Serializer

  root false

  def attributes
    attrs = super
    attrs.tap do 
      attrs[:activities] = activities
    end
  end

  def activities
    object[:activities].collect do |activity|
      ActivitySerializer.new(activity).as_json
    end
  end

end