module FixtureHelper
  def fixture_content(path)
    File.open(File.join(root_path, "support", "fixtures", path)).read
  end
end
