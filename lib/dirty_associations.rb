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

      define_method "#{association}_attributes=" do |value|
        attribute_will_change!(association.to_s) if _nested_attributes_will_change?(value)
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
    send(ids).map(&:to_s) != value.map(&:to_s)
  end

  def _nested_attributes_will_change?(attributes_collection)
    return false unless attributes_collection.is_a?(Array) || attributes_collection.is_a?(Hash)
    attributes_collection = attributes_collection.values if attributes_collection.is_a? Hash

    # Only consider additions to be a change, i.e. attributes hashes with no id. Editing or destroying a
    # nested model can be detected by belongs_to :touch => true on the nested model class.
    attributes_collection.any? { |a| a[:id].blank? && a["id"].blank?}
  end
end
