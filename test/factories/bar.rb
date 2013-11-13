FactoryGirl.define do
  factory :bar do
    association :foos, factory: :foo
  end
end
