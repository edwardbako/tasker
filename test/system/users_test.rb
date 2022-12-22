require "application_system_test_case"
require_relative "../helpers/sign_in_helper"
class UsersTest < ApplicationSystemTestCase
  setup do
    @task = create :task_in_progress
    @task.in_progress!
    @user = create :user
    sign_in(@user)
  end

  test "visiting the index" do
    visit users_url
    assert_selector "h1", text: "Tasks for approval"
    assert_selector ".users", text: @task.owner.email
  end

  test "shows another users tasks for approval" do
    visit users_url
    click_on @task.owner.email
    assert_selector ".tasks"
    assert_selector "#task_#{@task.id}", text: @task.title
  end

  test "User approves task" do
    visit users_url
    click_on @task.owner.email
    find("#task_#{@task.id} .btn", text: "Approve").click
    assert_selector "#task_#{@task.id} .btn", text: "APPROVED"
  end
end
