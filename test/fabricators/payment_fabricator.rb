Fabricator(:payment) do
  date       { Date.today }
  amount     1.5
  concept    { Faker::Lorem.words(4).join(' ') }
  partner_id { Fabricate(:partner).id }
  user_id    { Fabricate(:user).id }
end
