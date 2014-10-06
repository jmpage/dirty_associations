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
      define_method "#{association}=" do |value|
        attribute_will_change!(association.to_s) if _association_will_change?(association, value)
        super(value)
      end

      ids = "#{association.to_s.singularize}_ids"

      define_method "#{ids}=" do |value|
        attribute_will_change!(association.to_s) if _ids_will_change?(ids, value)
        super(value)
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

  private

  def _association_will_change?(association, value)
    send(association) != value
  end

  def _ids_will_change?(ids, value)
    value = Array(value).reject &:blank?
    send(ids) != value
  end
end
