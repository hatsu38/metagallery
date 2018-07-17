class Service < ApplicationRecord
  has_many :service_keywords
  has_many :keywords, :through => :service_keywords
end
