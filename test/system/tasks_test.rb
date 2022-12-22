require "application_system_test_case"
require_relative "../helpers/sign_in_helper"

class TasksTest < ApplicationSystemTestCase
  setup do
    @user = create :user
    sign_in(@user)
  end

  test "visiting the index" do
    visit tasks_url
    assert_selector "h1", text: "Tasks"
    assert_all_of_selectors "#tasks", "#newest_tasks", "#in_progress_tasks", "#completed_tasks", "#canceled_tasks"
  end

  test "should create task" do
    visit tasks_url

    title = Faker::Hobby.activity
    fill_in "task_deadline", with: Faker::Date.forward(days: 30)
    fill_in "task_title", with: title
    click_on "Create Task"
    assert_text "Task was successfully created"
    assert_selector ".task", text: title
  end

  test "should Start Task" do
    @task = create :task, owner: @user
    visit tasks_url
    click_on "Start"
    find("#task_#{@task.id}").assert_ancestor "#in_progress_tasks"
    assert_text "Task was successfully updated"
  end

  test "should cancel task" do
    @task = create :task, owner: @user
    @task.in_progress!
    visit tasks_url
    find("#task_#{@task.id} .bi-x").click
    assert_text "Task was successfully updated"
    find("#task_#{@task.id}").assert_ancestor "#canceled_tasks"
  end

  test "should complete task" do
    @task = create :approved_task_in_progress, owner: @user
    visit tasks_url
    find("#task_#{@task.id} .bi-check").click
    assert_text "Task was successfully updated"
    find("#task_#{@task.id}").assert_ancestor "#completed_tasks"
  end

  test "should destroy Task" do
    @task = create :task, owner: @user
    visit tasks_url
    find(:css, "#task_#{@task.id} .bi-trash").click
    assert_text "Task was successfully destroyed"
    assert_no_selector "#task_#{@task.id}"
  end
end
