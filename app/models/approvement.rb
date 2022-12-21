class Approvement < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates_uniqueness_of :task, scope: :user, message: "This user has already approved this task"
  # validates :user
  validates_exclusion_of :user, in: ->(approvement) { [approvement.task.owner] },
                         message: "Owner could not approve self tasks"
end
