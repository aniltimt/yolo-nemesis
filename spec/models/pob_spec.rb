require 'spec_helper'

describe Pob do
  it { have_and_belong_to_many(:pob_categories) }
end
