class Service < ApplicationRecord
  has_many :service_keywords, dependent: :destroy
  has_many :keywords, :through => :service_keywords
end
