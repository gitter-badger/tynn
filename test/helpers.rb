require_relative "helper"

module Helper
  def clean(str)
    return str.strip
  end

  module Number
    def number
      return 1
    end
  end

  def self.setup(app)
    app.helpers(Number)
  end

  module ClassMethods
    def foo
      "foo"
    end
  end
end

setup do
  Driver.new(Tynn)
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
