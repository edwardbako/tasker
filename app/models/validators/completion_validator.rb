class CompletionValidator < ActiveModel::Validator
  def validate(record)
    if record.completed? && record.approvers.size < minimum_allowed_approvers
      record.errors.add :base, "Task must be approved by #{minimum_allowed_approvers} users minimum"
    end
  end

  private

  def minimum_allowed_approvers
    2
  end
end
