require 'rubygems' rescue nil
require 'rake'

CODE = Dir.glob('*.rb') + Dir.glob('lib/**/*.rb')

task :default => :test

desc 'Run all tests'
task :test => %w[test:roodi test:flog test:flay test:rcov]

desc 'Run the game'
task :run do
  system('rsdl main.rb') or system('ruby main.rb')
end

namespace :test do
  require 'spec/rake/spectask'
  spec_opts = %w[--colour --format progress]
  rcov_opts = %w[--text-report --include spec --exclude spec/*,gems/*,features/*]
  desc 'Run all specs in spec directory with RCov (excluding plugin specs)'
  Spec::Rake::SpecTask.new(:spec) do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.rcov = true
    t.spec_opts = spec_opts
    t.rcov_opts = rcov_opts
  end

  require 'spec/rake/verify_rcov'
  desc 'Run all examples with RCov'
  RCov::VerifyTask.new(:rcov => :spec) do |t|
    t.threshold = 100.0
    t.require_exact_threshold = false
  end

  require 'roodi'
  require 'roodi_task'
  RoodiTask.new(:roodi, CODE)

  desc 'Analyze for code complexity'
  task :flog do
    require 'flog'
    flog = Flog.new(:methods => true)
    flog.flog(CODE)
    threshold = 20
    bad_methods = flog.totals.select do |name, score|
      score > threshold
    end
    bad_methods.sort { |a,b| a.last <=> b.last }.each do |name, score|
      puts format('The method "%s" has exceeded complexity threshold with %f', name, score)
    end
    puts 'Complexity: No offensive methods found' if bad_methods.empty?
    raise "#{bad_methods.size} methods have a flog complexity > #{threshold}" unless bad_methods.empty?
  end

  desc 'Analyze for code duplication'
  task :flay do
    require 'flay'
    flay = Flay.new(:fuzzy => false, :verbose => false, :mass => 30)
    flay.process(*CODE)
    print 'Duplication: '
    flay.report
    raise "#{flay.masses.size} chunks of code have a duplicate mass > #{threshold}" unless flay.masses.empty?
  end
end
