class TasksController < ApplicationController
  before_action :set_task, only: %i[ update destroy ]

  # GET /tasks or /tasks.json
  def index
    set_new_task
    set_tasks
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_url, notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        set_tasks
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @updatable_task.update(task_params)
        format.html { redirect_to tasks_url, notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @updatable_task }
      else
        set_new_task
        set_tasks
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @updatable_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @updatable_task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @updatable_task = Task.find(params[:id])
    end

    def set_new_task
      @task = Task.new(owner: current_user)
    end

    def set_tasks
      @tasks = Task.states.keys.to_h do |key|
        [key, Task.includes(:owner, :approvements, :approvers).where(owner: current_user).send(key).order(:deadline)]
      end
    end
    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :state, :completed_at, :canceled_at, :deadline, :owner_id)
    end
end
