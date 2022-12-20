module TasksHelper
  def blocks
    Task.states.keys.map(&:humanize)
  end
end
