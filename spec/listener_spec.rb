require_relative "../lib/rami/listener"
include RAMI

@ip   = "127.0.0.1"
@port = 5038

describe Listener do
  it "should open socket" do
    Listener.new(@ip, @port).sock.should_not == nil
  end

  it "should login" do
    Listener.new(@ip, @port).login
  end
end
