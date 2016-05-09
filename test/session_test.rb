# frozen_string_literal: true

require_relative "helper"
require_relative "../lib/tynn/session"

class SessionTest < Minitest::Test
  test "raises error if secret is empty" do
    assert_raises { new_app.plugin(Tynn::Session) }
  end

  test "sets session" do
    app = new_app

    app.plugin(Tynn::Session, secret: "__an_insecure_secret_key")

    app.define do
      get do
        session[:foo] = "foo"

        res.write(session[:foo])
      end
    end

    ts = Tynn::Test.new(app)
    ts.get("/")

    assert_equal "foo", ts.res.body
    assert_equal "foo", ts.req.session["foo"]
  end
end
