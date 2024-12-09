class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.human_attribute_enum_value(attr_name, value)
    return if value.blank?
    human_attribute_name("#{attr_name}.#{value}")
  end

  def human_attribute_enum(attr_name)
    self.class.human_attribute_enum_value(attr_name, self.send("#{attr_name}"))
  end

  def self.enum_options_for_select(attr_name)
    self.send(attr_name.to_s.pluralize).map { |key, value| [ self.human_attribute_enum_value(attr_name, key), value ] }.to_h
  end

  def self.enum_options_for_radio(attr_name)
    self.send(attr_name.to_s.pluralize).map { |k, _| [self.human_attribute_enum_value(attr_name, k), k] }.to_h
  end
end
