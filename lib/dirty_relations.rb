##
# This concern can be used to monitor relations for changes.
#
# Associations monitored using the methods in this concern will show up in the ActiveRecord model's changes,
# changed and previous_changes methods.
module DirtyRelations
  extend ActiveSupport::Concern

  module ClassMethods

    ##
    # Creates methods that allows an association named +field+ to be monitored.
    #
    # The +field+ parameter should be a string or symbol representing the name of an association.
    def monitor_association_changes(field)
      [field, "#{field.to_s.singularize}_ids"].each do |name|
        define_method "#{name}=" do |value|
          attribute_will_change!(field)
          super(value)
        end

        define_method "#{name}_changed?" do
          changed.include?(field)
        end

        define_method "#{name}_previously_changed?" do
          previous_changes.keys.include?(field.to_s)
        end
      end
    end
  end
end
