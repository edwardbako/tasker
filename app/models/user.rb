class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tasks, foreign_key: :owner_id
  has_many :approvements, dependent: :destroy
  has_many :approved_tasks, through: :approvements, source: :task
end
