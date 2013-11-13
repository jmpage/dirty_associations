class Bar < ActiveRecord::Base
  include DirtyRelations

  has_many :foos
  monitor_association_changes :foos
end
