require "rack/file"

class Tynn
  module SendFile
    def send_file(path)
      file = Rack::File.new(nil)
      file.path = path

      return halt(file.serving(env))
    rescue Errno::ENOENT
      res.status = 404
    end
  end
end
