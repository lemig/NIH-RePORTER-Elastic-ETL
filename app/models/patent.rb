class Patent < ActiveRecord::Base
  include Indexable
  
  belongs_to :exporter_file
end
