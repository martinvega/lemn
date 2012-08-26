# -*- coding: utf-8 -*-
Fabricator(:partner) do
  name           { Faker::Name.first_name }
  lastname       { Faker::Name.last_name }
  address        { Faker::Lorem.sentence }
  user_id        { Fabricate(:user).id }
  phone          { sequence(:phone, 4111111) }
  mobile_phone   { sequence(:mobile_phone, 155111111) }
  email          { |attrs|
    Faker::Internet.email([attrs[:name], sequence(1)].join('_'))
  }
  admission_date { Date.today.years_ago(1) }
  birth_date     { Date.today.years_ago(30) }
  document       { sequence(:document, 20897899) }
end
