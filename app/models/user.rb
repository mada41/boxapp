class User < ActiveRecord::Base
	include CleanChildren

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :boxes # no dependent destroy, see include CleanChildren concern model
  has_many :ssh_keys, dependent: :destroy

  has_and_belongs_to_many :invited_boxes, class_name: 'Box', join_table: 'boxes_users'
end
