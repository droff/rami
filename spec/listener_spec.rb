require_relative "spec_helper"
require_relative "../lib/rami/listener"
include RAMI

config = YAML::load_file("config.yml")["rami"]

describe Listener do
  it "should open socket" do
    Listener.new(config["host"], config["port"]).sock.should_not == nil
  end
end
