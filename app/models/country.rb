class Country < ActiveRecord::Base
  attr_accessible :name, :code, :region
end
