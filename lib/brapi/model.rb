# frozen_string_literal: true

require "date"
require "time"

module Brapi
  class Model
    class << self
      def attribute(name, type: nil, json_key: nil)
        attr_reader name

        attribute_specs[name] = { type: type, json_key: json_key&.to_s || camelize(name.to_s) }
      end

      def attribute_specs
        @attribute_specs ||= begin
          parent = superclass.respond_to?(:attribute_specs) ? superclass.attribute_specs : {}
          parent.dup
        end
      end

      def from_h(value)
        return nil if value.nil?
        return value if value.is_a?(self)

        new(value)
      end

      def camelize(snake)
        head, *rest = snake.split("_")
        ([head] + rest.map(&:capitalize)).join
      end
    end

    def initialize(hash = {})
      hash ||= {}
      hash = hash.transform_keys(&:to_s) if hash.respond_to?(:transform_keys)
      @raw = hash
      self.class.attribute_specs.each do |name, spec|
        value = hash[spec[:json_key]]
        value = hash[name.to_s] if value.nil?
        instance_variable_set("@#{name}", coerce(value, spec[:type]))
      end
    end

    def to_h
      self.class.attribute_specs.each_with_object({}) do |(name, _), h|
        value = public_send(name)
        h[name] = serialize(value)
      end
    end

    def [](name)
      public_send(name) if respond_to?(name)
    end

    def ==(other)
      other.is_a?(self.class) && other.to_h == to_h
    end
    alias eql? ==

    def hash
      to_h.hash
    end

    attr_reader :raw

    private

    def coerce(value, type)
      return nil if value.nil?

      case type
      when :string  then value.to_s
      when :integer then Integer(value)
      when :float   then Float(value)
      when :boolean then !!value
      when :time    then parse_time(value)
      when :date    then parse_date(value)
      when Array    then Array(value).map { |v| coerce(v, type.first) }
      when Class    then type.respond_to?(:from_h) ? type.from_h(value) : value
      else value
      end
    end

    def serialize(value)
      case value
      when Brapi::Model     then value.to_h
      when Array            then value.map { |v| serialize(v) }
      when Time             then value.iso8601
      else value
      end
    end

    def parse_time(value)
      return value if value.is_a?(Time)

      Time.parse(value.to_s)
    rescue ArgumentError, TypeError
      nil
    end

    def parse_date(value)
      return value if value.is_a?(Date)

      Date.parse(value.to_s)
    rescue ArgumentError, TypeError
      nil
    end
  end
end
