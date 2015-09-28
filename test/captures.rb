require_relative "helper"

setup do
  Driver.new(Tynn)
end

test "captures" do |app|
  Tynn.define do
    on :foo do
      on :bar do
        res.write(sprintf("%s:%s", inbox[:foo], inbox[:bar]))
      end
    end
  end

  app.get("/foo/bar")

  assert_equal 200, app.res.status
  assert_equal "foo:bar", app.res.body
end
