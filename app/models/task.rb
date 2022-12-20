class Task < ApplicationRecord
  belongs_to :owner, class_name: "User"

  enum state: [:newest, :in_progress, :completed, :canceled]

end
