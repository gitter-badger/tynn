require "benchmark/ips"
require "erubis"
require_relative "../lib/tynn"
require_relative "../lib/tynn/render"
require_relative "../lib/tynn/hmote"

TEMPLATES = File.expand_path("../examples", __dir__)

class TiltApp < Tynn
  helpers(Tynn::Render, views: File.join(TEMPLATES, "render/views"))

  define do
    root do
      render("home", title: "Thanks for using Tynn!")
    end
  end
end

class HMoteApp < Tynn
  helpers(Tynn::HMote, views: File.join(TEMPLATES, "hmote/views"))

  define do
    root do
      render("home", title: "Thanks for using Tynn!")
    end
  end
end

Benchmark.ips do |x|
  x.report("erubis") do |x|
    TiltApp.call("PATH_INFO" => "/")
  end

  x.report("hmote") do |x|
    HMoteApp.call("PATH_INFO" => "/")
  end

  x.compare!
end

# Calculating -------------------------------------
#               erubis     2.307k i/100ms
#                hmote     3.225k i/100ms
# -------------------------------------------------
#               erubis     67.270M (±35.0%) i/s -    252.561M
#                hmote    135.111M (±39.0%) i/s -    464.068M
#
# Comparison:
#                hmote: 135111185.4 i/s
#               erubis: 67270352.1 i/s - 2.01x slower
