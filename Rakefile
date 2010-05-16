require 'rake'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

rcov_opts = ["--text-report", "--include", "spec", "--exclude", "spec/*,gems/*,features/*"]
spec_opts = ["--colour", "--format", "progress"]

task :default => :rcov

desc "Run all specs in spec directory with RCov (excluding plugin specs)"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  t.spec_opts = spec_opts
  t.rcov_opts = rcov_opts
end

desc "Run all examples with RCov"
RCov::VerifyTask.new(:rcov => :spec) do |t|
  t.threshold = 100.0
  t.require_exact_threshold = false
end
