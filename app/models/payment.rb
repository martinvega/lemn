class Payment < ActiveRecord::Base
  attr_accessible :amount, :concept, :date, :partner_id
end
