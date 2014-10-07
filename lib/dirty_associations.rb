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

      define_method "#{association}_will_change!" do
        attribute_will_change!(association.to_s)
        attribute_will_change!(ids.to_s)
      end

      %i(before_add before_remove).each do |callback_name|
        full_callback_name = "#{callback_name}_for_#{association}"
        callbacks = send(full_callback_name)
        callback = ->(method, owner, record) { owner.send("#{association}_will_change!") }
        send("#{full_callback_name}=", callbacks + [callback])
      end

      [association, ids].each do |name|
        define_method "#{name}_change" do
          changes[name]
        end

        define_method "#{name}_changed?" do
          changes.has_key?(association.to_s)
        end

        define_method "#{name}_previously_changed?" do
          previous_changes.has_key?(association.to_s)
        end
      end
    end
  end
end
