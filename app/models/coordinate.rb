class Coordinate
  include Mongoid::Document
  include Mongoid::Timestamps

  field :type, type: String
  field :coordinates, type: Array

  embedded_in :plot, class_name: "Plot"

  validates :coordinates, presence: true
end
