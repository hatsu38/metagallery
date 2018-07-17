class Keyword < ApplicationRecord
  has_many :service_keywords
  has_many :services, :through => :service_keyword
end
