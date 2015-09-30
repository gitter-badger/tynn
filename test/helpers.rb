require_relative "helper"

module Helper
  def clean(str)
    return str.strip
  end

  module Number
    def self.setup(app, number)
      app.settings[:number] = number
    end

    def number
      return settings[:number]
    end
  end

  def self.setup(app, number = 1)
    app.helpers(Number, number)
  end

  module ClassMethods
    def foo
      "foo"
    end
  end
end

setup do
  Tynn::Test.new
end

test "helpers" do |app|
  Tynn.helpers(Helper)

  Tynn.define do
    get do
      res.write(clean(" foo "))
    end
  end

  app.get("/")

  assert_equal "foo", app.res.body
  assert_equal "foo", Tynn.foo
end

test "setup" do |app|
  Tynn.helpers(Helper)

  Tynn.define do
    res.write(number)
  end

  app.get("/")

  assert_equal "1", app.res.body
end

test "setup with arguments" do |app|
  Tynn.helpers(Helper, 2)

  Tynn.define do
    res.write(number)
  end

  app.get("/")

  assert_equal "2", app.res.body
end
