module ApplicationHelper
    def flash_class(name)
        mapping = {
          notice: :success,
          alert: :warning,
          error: :danger
        }.with_indifferent_access
        mapping.default = :info
    
        "alert-#{mapping[name]}"
      end
end
