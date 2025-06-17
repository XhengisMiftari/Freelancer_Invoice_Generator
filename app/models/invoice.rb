class Invoice < ApplicationRecord
  belongs_to :project
  monetize :price_cents

end
