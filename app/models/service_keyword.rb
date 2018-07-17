class ServiceKeyword < ApplicationRecord
  belongs_to :service
  belongs_to :keyword
end
