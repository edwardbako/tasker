class TransitionsValidator < ActiveModel::Validator
  attr_accessor :record

  def validate(record)
    @record = record
    unless record.state.to_sym.in? allowed_transitions[old_state]
      record.errors.add :state,
        "You cold change state form :#{old_state} to #{allowed_transitions[old_state]} but not to :#{record.state}"
    end
  end

  private

  def old_state
    record.class.find(record.id).state.to_sym
  end

  def allowed_transitions
    {
      newest: [:newest, :in_progress],
      in_progress: [:in_progress, :completed, :canceled],
      completed: [:completed],
      canceled: [:canceled]
    }
  end
end