require 'spec_helper'
require 'digest/md5'

describe Places::Storage::File do
  it 'writes data to specified file' do
    path_to_file = File.join(tmp_path, 'file.txt')
    local = Places::Storage::File.new(path_to_file)
    local.write('data')

    File.open(path_to_file).read.should == 'data'
  end
  
  it 'calculates etag of file' do
    path_to_file = File.join(tmp_path, 'file.txt')
    local = Places::Storage::File.new(path_to_file)
    
    File.open(path_to_file, 'w') do |f|
      f.write('data123')
    end
    
    local.etag.should == Digest::MD5.hexdigest('data123')
  end
end