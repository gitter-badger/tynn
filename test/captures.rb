test "captures" do
  Tynn.define do
    on :foo do
      on :bar do
        res.write(sprintf("%s:%s", inbox[:foo], inbox[:bar]))
      end
    end
  end

  app = Tynn::Test.new
  app.get("/foo/bar")

  assert_equal 200, app.res.status
  assert_equal "foo:bar", app.res.body
end
