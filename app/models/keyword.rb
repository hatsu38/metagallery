class Keyword < ApplicationRecord
  has_many :service_keywords, dependent: :destroy
  has_many :services, :through => :service_keyword
end
