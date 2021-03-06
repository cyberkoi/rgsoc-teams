FactoryGirl.define do
  factory :team do
    kind 'sponsored'
    sequence(:name) { |i| "#{i}-#{FFaker::Lorem.word}" }

    trait :helpdesk do
      name 'helpdesk'
    end

    trait :supervise do
      name 'supervise'
    end

    trait :applying_team do
      name { FFaker::Product.brand }

      after(:create) do |team|
        %w(student student mentor coach).each do |role|
          team.roles.create name: role, user: create(:user)
          team
        end
      end
    end

    trait :with_applications do
      after(:create) do |team|
        # team.applications.create build(:application, team: nil).attributes
        create_list :application, 2, team: team
        team
      end
    end
  end
end
