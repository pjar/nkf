class PodKategoria < ActiveRecord::Base
  has_and_belongs_to_many :kategorias
  has_many :firmas
  attr_accessible :liczba_firm, :nazwa
end
