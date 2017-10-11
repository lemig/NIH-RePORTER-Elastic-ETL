module Indexable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    index_name ["nih", self.table_name].join('_')
    document_type ["nil", self.model_name.singular].join('_')
  end

  def document_type
    self.class.document_type
  end
end
