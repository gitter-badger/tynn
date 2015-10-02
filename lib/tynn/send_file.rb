require "rack/file"

module Tynn::SendFile
  def send_file(path)
    file = Rack::File.new(nil)
    file.path = path

    halt(file.serving(env))
  rescue Errno::ENOENT
    res.status = 404
  end
end
