class LocationSerializer < ActiveModel::Serializer
  attributes :id, :name, :has_code_reviews
end