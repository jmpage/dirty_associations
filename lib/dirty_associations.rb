##
# This concern can be used to monitor associations for changes.
#
# Associations monitored using the methods in this concern will show up in the ActiveRecord model's changes,
# changed and previous_changes methods.
module DirtyAssociations
  extend ActiveSupport::Concern

  module ClassMethods

    ##
    # Creates methods that allows an +association+ to be monitored.
    #
    # The +association+ parameter should be a string or symbol representing the name of an association.
    def monitor_association_changes(association)
      ids = "#{association.to_s.singularize}_ids"
      attributes = "#{association.to_s}_attributes"

      [association, ids].each do |name|
        define_method "#{name}=" do |value|
          attribute_will_change!(name)
          super(value)
        end

        define_method "#{name}_changed?" do
          changes.has_key?(name.to_s)
        end

        define_method "#{name}_previously_changed?" do
          previous_changes.has_key?(name.to_s)
        end
      end
    end
  end
end
