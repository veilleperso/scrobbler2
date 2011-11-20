require 'rake'
require 'rake/testtask'
require 'rdoc/task'
require 'spec/rake/spectask'

Dir['tasks/**/*.rake'].each { |rake| load rake }

task :default => 'test:unit'
