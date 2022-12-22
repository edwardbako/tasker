require "test_helper"

class ApprovementTest < ActiveSupport::TestCase
  test "Owner of task could not be approver" do
    task = create :task
    owner = task.owner
    approvement = build(:approvement, task: task, user: owner)
    assert_not approvement.valid?

  end

  test "One user could approve one task ONLY" do
    task = create :task
    user = create :user
    approvement = build(:approvement, task: task, user: user)
    assert approvement.save
    approvement = build(:approvement, task: task, user: user)
    assert_not approvement.valid?
  end
end
