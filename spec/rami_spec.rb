require_relative "spec_helper"
require_relative "../lib/rami"

describe RAMI do
  it "fields should be a hash" do
    RAMI::fields(["key: VALUE"]).should be_kind_of Hash
  end
end
