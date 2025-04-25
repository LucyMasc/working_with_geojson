class CollectPoint
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: 'collect_point'

  field :name, type: String
  field :coordinates, type: Array

  has_and_belongs_to_many :plots

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :coordinates, presence: true
end
