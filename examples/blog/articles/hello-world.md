title: Hello World!

This is how a "Hello World" app looks like:

    require "tynn"

    Tynn.define do
      get do
        res.write("Hello World!")
      end
    end
