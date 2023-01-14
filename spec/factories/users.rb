FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "#{email.split('@')[0]}pass123" }
    description { Faker::Lorem.sentence }
  end

  factory :merchant, parent: :user, class: Merchant do
    admin
  end

  factory :admin, parent: :user, class: Admin do
  end
end
