$:.unshift File.expand_path(./../lib, __FILE__)
require ''
describe  do
  it  do
    expect(function(arguments)).to eq(result)
  end
end
