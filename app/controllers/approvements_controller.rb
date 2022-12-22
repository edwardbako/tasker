class ApprovementsController < ApplicationController

  def create
    @task = Task.find(approvement_params[:task_id])
    @approvement = Approvement.new(task: @task, user: current_user)

    respond_to do | format|
      if @approvement.save
        format.html { redirect_to user_url(@task.owner.id), notice: "Task was successfully updated"}
      else
        flash[:error] = @approvement.errors.full_messages.join(", ")
        format.html { redirect_to user_url(@task.owner.id) }
      end
    end
  end

  private

  def approvement_params
    params.require(:approvement).permit(:task_id)
  end
end
