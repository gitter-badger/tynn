require_relative "helper"
require_relative "../lib/tynn/session"

class SessionTest < Tynn::TestCase
  class App < Tynn
    plugin Tynn::Session, secret: "__an_insecure_secret_key"

    define do
      get do
        session[:foo] = "foo"

        res.write(session[:foo])
      end
    end
  end

  test "raises error if secret is empty" do
    assert_raises(Tynn::Session::NoSecretError) do
      Tynn.plugin(Tynn::Session)
    end
  end

  test "session" do
    app = Tynn::Test.new(App)
    app.get("/")

    assert_equal "foo", app.res.body
    assert_equal "foo", app.req.session["foo"]
  end
end
