class Box < ActiveRecord::Base
  include ContainerStatus
  include CleanChildren

  belongs_to :user
  has_many :components # no dependent destroy, see include CleanChildren concern model
  has_and_belongs_to_many :invited_users, class_name: 'User', join_table: 'boxes_users'

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true
end
