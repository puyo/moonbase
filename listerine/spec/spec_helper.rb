Spec::Runner.configure do |config|
  config.before(:all) do
    Moonbase.logger = Logger.new(File.expand_path('../log/test.log', File.dirname(__FILE__)))
  end
end
