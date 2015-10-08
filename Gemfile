source "https://rubygems.org"

File.readlines(".gems").each do |dep|
  gem(*dep.chomp.split(":"))
end
