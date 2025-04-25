class Plot
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: 'plot'

  field :name, type: String

  embeds_many :coordinates, class_name: "Coordinate"
  has_and_belongs_to_many :collect_points

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
