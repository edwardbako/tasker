json.extract! task, :id, :title, :state, :completed_at, :canceled_at, :deadline, :owner_id, :created_at, :updated_at
json.url task_url(task, format: :json)
