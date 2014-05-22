#require File.expand_path('spec/spec_helper')
require_relative "../lib/rami"

describe RAMI do
  it "fields should be a hash" do
    RAMI::fields(["a: A"]).should.class == Hash
  end
end
