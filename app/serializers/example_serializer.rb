# frozen_string_literal: true
# :nodoc:
class ExampleSerializer < ActiveModel::Serializer
  attributes :id, :name

  def id
    object.uid
  end

  def name
    "#{object.firstname} #{object.lastname}"
  end
end
