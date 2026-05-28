# frozen_string_literal: true

RSpec.describe Brapi::Model do
  let(:test_class) do
    Class.new(described_class) do
      attribute :name, type: :string
      attribute :age, type: :integer
      attribute :balance, type: :float
      attribute :active, type: :boolean
      attribute :created_at, type: :time
      attribute :nickname, type: :string, json_key: "nick"
      attribute :tags
    end
  end

  describe ".from_h" do
    it "returns nil for nil input" do
      expect(test_class.from_h(nil)).to be_nil
    end

    it "passes through existing instances" do
      inst = test_class.from_h(name: "Foo")
      expect(test_class.from_h(inst)).to be(inst)
    end

    it "coerces values according to declared types" do
      m = test_class.from_h(
        "name" => 123,
        "age" => "42",
        "balance" => "3.14",
        "active" => 1,
        "createdAt" => "2026-05-28T10:00:00Z",
        "nick" => "rom",
        "tags" => %w[a b]
      )

      expect(m.name).to eq("123")
      expect(m.age).to eq(42)
      expect(m.balance).to eq(3.14)
      expect(m.active).to be(true)
      expect(m.created_at).to eq(Time.utc(2026, 5, 28, 10))
      expect(m.nickname).to eq("rom")
      expect(m.tags).to eq(%w[a b])
    end

    it "maps snake_case attributes to camelCase JSON keys by default" do
      m = test_class.from_h("createdAt" => "2026-05-28T00:00:00Z")
      expect(m.created_at).to be_a(Time)
    end

    it "honors explicit json_key overrides" do
      m = test_class.from_h("nick" => "rom")
      expect(m.nickname).to eq("rom")
    end

    it "tolerates missing keys (assigns nil)" do
      m = test_class.from_h({})
      expect(m.name).to be_nil
      expect(m.age).to be_nil
    end
  end

  describe "#to_h" do
    it "serializes back to a Hash with snake_case keys" do
      m = test_class.from_h(name: "Foo", age: 30)
      expect(m.to_h).to include(name: "Foo", age: 30)
    end

    it "serializes Time as ISO 8601" do
      m = test_class.from_h(createdAt: "2026-05-28T10:00:00Z")
      expect(m.to_h[:created_at]).to eq("2026-05-28T10:00:00Z")
    end
  end

  describe "nested model coercion" do
    let(:inner_class) do
      Class.new(described_class) do
        attribute :label, type: :string
      end
    end

    let(:outer_class) do
      inner = inner_class
      Class.new(described_class) do
        attribute :child, type: inner
        attribute :children, type: [inner]
      end
    end

    it "coerces single nested model" do
      o = outer_class.from_h("child" => { "label" => "Hi" })
      expect(o.child).to be_a(inner_class)
      expect(o.child.label).to eq("Hi")
    end

    it "coerces array of nested models" do
      o = outer_class.from_h("children" => [{ "label" => "a" }, { "label" => "b" }])
      expect(o.children.map(&:label)).to eq(%w[a b])
    end
  end

  describe "#raw" do
    it "preserves the original payload" do
      raw = { "name" => "Foo", "extraField" => 99 }
      m = test_class.from_h(raw)
      expect(m.raw).to eq(raw)
    end
  end

  describe "equality" do
    it "considers two instances with same attributes equal" do
      a = test_class.from_h(name: "Foo", age: 1)
      b = test_class.from_h(name: "Foo", age: 1)
      expect(a).to eq(b)
    end

    it "differentiates by class" do
      other = Class.new(described_class) { attribute :name, type: :string }
      a = test_class.from_h(name: "x")
      b = other.from_h(name: "x")
      expect(a).not_to eq(b)
    end
  end
end
