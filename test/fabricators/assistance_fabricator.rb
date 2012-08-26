Fabricator(:assistance) do
  date       { Date.today }
  partner_id { Fabricate(:partner).id }
  user_id    { Fabricate(:user).id }
end
