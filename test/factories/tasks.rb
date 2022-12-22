FactoryBot.define do
  factory :task do
    owner factory: :user
    title { Faker::Hobby.activity }
    deadline { Faker::Date.forward(days: 30) }

    factory :task_without_title do
      title {}
    end

    factory :task_without_deadline do
      deadline {}
    end

    factory :task_without_owner do
      owner {}
    end

    factory :task_in_progress do
      state { :in_progress }
    end

    factory :task_with_approvements do
      transient do
        approvements_count { 1 }
      end

      approvements do
        Array.new(approvements_count) { association(:approvement, task: instance)}
      end

      factory :approved_task do
        transient do
          approvements_count { 2 }
        end

        factory :approved_task_in_progress do
          state { :in_progress }
        end

        factory :completed_task do
          state { :completed }
        end

        factory :canceled_task do
          state { :canceled }
        end
      end
    end
  end
end