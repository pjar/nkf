class Kategoria < ActiveRecord::Base
  has_many :firmas
  attr_accessible :glowna, :nazwa
end
