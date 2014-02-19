module PathHelper
  def root_path
    @root_path ||= File.expand_path('../../../', __FILE__);
  end
  
  def tmp_path
    File.join(root_path, 'tmp')
  end
end
