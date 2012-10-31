class Firma < ActiveRecord::Base
  belongs_to :kategoria
  belongs_to :pod_kategoria
  attr_accessible :adres, :description, :fax, :link, :nazwa, :tel, :website, :logo_url, :uniq_id, :sub_kategoria
end
