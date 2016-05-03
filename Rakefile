# frozen_string_literal: true

require "bundler/setup"

require "rake/testtask"

task default: :test

Rake::TestTask.new do |t|
  t.pattern = "test/*_test.rb"
  t.warning = true
end

require "rdoc/task"

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "doc"
  rdoc.rdoc_files.add("lib/**/*.rb")
  rdoc.options += ["--title", "Tynn: A thin library for web development"]
end
