class Bar < ActiveRecord::Base
  include DirtyAssociations

  has_many :foos
  monitor_association_changes :foos
  accepts_nested_attributes_for :foos
end
