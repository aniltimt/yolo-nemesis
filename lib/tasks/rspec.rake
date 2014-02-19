# copied from rspec-rails rake task
if defined?(RSpec)
  spec_prereq = Rails.configuration.generators.options[:rails][:orm] == :active_record ?  "db:test:prepare" : :noop
  task :noop do; end

  namespace :spec do
    [:admin, :v1].each do |app_part|
      desc "Run all specs for #{app_part}"
      RSpec::Core::RakeTask.new(app_part => spec_prereq) do |t|
        t.pattern = "./spec/**/#{app_part}/**/*_spec.rb"
      end
      namespace app_part do
        [:requests, :models, :controllers, :views, :helpers, :mailers, :lib, :routing].each do |sub|
          desc "Run the code examples in spec/#{sub} for #{app_part}"
          RSpec::Core::RakeTask.new(sub => spec_prereq) do |t|
            t.pattern = "./spec/#{sub}/#{app_part}/**/*_spec.rb"
          end
        end
      end
    end
  end
end