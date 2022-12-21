class Task < ApplicationRecord
  belongs_to :owner, class_name: "User"

  enum state: [:newest, :in_progress, :completed, :canceled]

  validates_presence_of :title, :deadline

  before_create :set_newest

  private

  def set_newest
    self.state = :newest
  end
end
