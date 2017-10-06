class AddOrgIpfCodeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :org_ipf_code, :string, index: true
  end
end
