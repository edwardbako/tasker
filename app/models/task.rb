class Task < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :approvements, dependent: :destroy
  has_many :approvers, through: :approvements, source: :user

  enum state: [:newest, :in_progress, :completed, :canceled]

  validates_presence_of :title, :deadline
  validates_with CompletionValidator

  before_create :set_newest
  before_update :set_timestamps, if: :timestampable

  def approved?
    approvers.size >= CompletionValidator::MINIMUM_ALLOWED_APPROVERS
  end
  private
  def set_timestamps
    send("set_#{state}_at")
  end
  def timestampable
    state.to_sym.in? self.class.timestampable_states
  end
  def set_newest
    self.state = :newest
  end

  def self.timestampable_states
    [:completed, :canceled]
  end

  timestampable_states.each do |m|
    define_method("set_#{m}_at") do
      self.send("#{m}_at=", Time.now)
    end
  end
end
