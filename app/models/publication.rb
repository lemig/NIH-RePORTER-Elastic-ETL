class Publication < ActiveRecord::Base
  belongs_to :exporter_file
  has_and_belongs_to_many :authors, class_name: 'Person'

  def author_names
    author_list.to_s.gsub('<![CDATA[','').gsub(']]>','').split(';').map(&:strip)
  end
end
