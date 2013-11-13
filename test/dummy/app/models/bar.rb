class Bar < ActiveRecord::Base
  include DirtyAssociations

  has_many :foos
  monitor_association_changes :foos
end
