class CompletionValidator < ActiveModel::Validator
  MINIMUM_ALLOWED_APPROVERS = 2
  def validate(record)
    if record.completed? && record.approvers.size < MINIMUM_ALLOWED_APPROVERS
      record.errors.add :base, "Task must be approved by #{MINIMUM_ALLOWED_APPROVERS} users minimum"
    end
  end

end
