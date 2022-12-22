require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "Should not save task without title" do
    task = build :task_without_title
    assert_not task.save
  end

  test "Should not save task without deadline" do
    task = build :task_without_deadline
    assert_not task.save
  end

  test "Should not save task without owner" do
    task = build :task_without_owner
    assert_not task.save
  end

  test "Should set newest state on task creation" do
    task = create :task
    assert_equal :newest, task.state.to_sym
  end

  test "Should set timestamp on cancelation" do
    task = create :task_in_progress
    task.in_progress!
    freeze_time do
      task.canceled!
      assert_equal Time.now, task.canceled_at
    end
  end

  test "Should set timestamp on completion" do
    task = create :approved_task_in_progress
    task.in_progress!
    freeze_time do
      task.completed!
      assert_equal Time.now, task.completed_at
    end
  end

  test "Should not complete without approvements" do
    task = build :task
    task.in_progress!
    assert_raise { task.completed!}
  end

  test "Should not complete with not enough approvements" do
    task = build :task_with_approvements
    task.in_progress!
    assert_raise { task.completed! }
  end

  test "Should change state from :newest to :in_progress ONLY" do
    task = create :approved_task
    task.state = :completed
    assert_not task.valid?
    task.state = :canceled
    assert_not task.valid?
    assert task.in_progress!
  end

  test "Approved task in progress could be canceled" do
    task = create :approved_task_in_progress
    task.in_progress!
    assert task.canceled!
  end

  test "Approved task in progress could be completed" do
    task = create :approved_task_in_progress
    task.in_progress!
    assert task.completed!
  end

  test "Task in progress should not become newest" do
    task = create :task
    task.in_progress!
    task.state = :newest
    assert_not task.valid?
  end

  test "completed task should not change state" do
    task = create :approved_task
    task.in_progress!
    task.completed!

    task.state = :canceled
    assert_not task.valid?
    task.state = :in_progress
    assert_not task.valid?
    task.state = :newest
    assert_not task.valid?
  end

  test "canceled task should not change state" do
    task = create :approved_task
    task.in_progress!
    task.canceled!

    task.state = :completed
    assert_not task.valid?
    task.state = :in_progress
    assert_not task.valid?
    task.state = :newest
    assert_not task.valid?
  end
end
