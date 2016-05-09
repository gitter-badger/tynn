# frozen_string_literal: true

class Tynn
  class Error < StandardError
  end

  class MissingHandlerError < Error
    def initialize(app) # :nodoc:
      super("Application handler is missing. Try #{ app }.define {}")
    end
  end
end
