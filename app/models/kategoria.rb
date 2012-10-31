class Kategoria < ActiveRecord::Base
  has_many :firmas
  has_and_belongs_to_many :pod_kategorias
  attr_accessible :glowna, :nazwa
end
