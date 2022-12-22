class Approvement < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates_uniqueness_of :task, scope: :user, message: "have been approved by this user"

  validates_exclusion_of :user, in: ->(approvement) { [approvement.task.owner] },
                         message: "Owner could not approve self tasks"
end
