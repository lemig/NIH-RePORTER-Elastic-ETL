class Organization < ActiveRecord::Base
  include Indexable
  
  has_and_belongs_to_many :projects

  def get_info
    return {} unless duns
    info = Sam.get_info(duns)
    info[:country] =  Country.find_country_by_alpha3(info[:country]).alpha2 if info[:country]
    info
  end

  def full_address
    [
      address,
      city,
      "#{state} #{zip}",
      country
    ]
    .compact
    .join(', ')
    .strip
  end
end
