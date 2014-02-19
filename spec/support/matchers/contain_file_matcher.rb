RSpec::Matchers.define :contain_file do |path|
  match do |dir_path|
    File.exists?(File.join(dir_path, path))
  end
end