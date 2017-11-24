class Abstract < ActiveRecord::Base
  belongs_to :exporter_file
  belongs_to :project, foreign_key: :application_id, primary_key: :application_id
end
