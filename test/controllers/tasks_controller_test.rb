require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task = create :task
    @user = create :user
    sign_in(@user)
  end

  test "should get index" do
    get tasks_url
    assert_response :success
  end

  test "should return JSON array to API request" do
    get tasks_url params: { states: [:newest] }, format: :json

    assert_equal @task.id, response.parsed_body.first["id"]
    assert_response :success
  end

  test "should return JSON array of all tasks to blank query given" do
    get tasks_url format: :json

    assert_equal 1, response.parsed_body.size
  end

  test "should create task" do
    assert_difference("Task.count") do
      post tasks_url, params: { task: { deadline: @task.deadline, owner_id: @task.owner_id, title: @task.title } }
    end

    assert_redirected_to tasks_url
  end


  test "should update task" do
    patch task_url(@task), params: { task: { state: :in_progress } }
    assert_equal :in_progress, @task.reload.state.to_sym
    assert_redirected_to tasks_url
  end

  test "should destroy task" do
    assert_difference("Task.count", -1) do
      delete task_url(@task)
    end

    assert_redirected_to tasks_url
  end
end
