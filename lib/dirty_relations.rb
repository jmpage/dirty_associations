module DirtyRelations
  extend ActiveSupport::Concern

  module ClassMethods
    def monitor_relation_changes(field)
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
