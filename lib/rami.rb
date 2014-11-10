require 'time'

require_relative 'rami/daemon'
require_relative 'rami/listener'

module RAMI

  def self.fields(responce)
    parse_values(toHash(responce))
  end

  private

  def self.toHash(arr)
    h = {}
    arr.each do |r|
      a = r.gsub("\"", "").split(": ")
      h[a[0].downcase.to_sym] = a[1] if a[0]
    end
    h
  end

  def self.parse_values(h)
    h[:created_at] = Time.now
    h[:starttime] &&= Time.parse(h[:starttime])
    h[:answertime] &&= Time.parse(h[:answertime])
    h[:endtime] &&= Time.parse(h[:endtime])
    h[:destinationchannel] = h[:destinationchannel].match(/(\d{1,})/)[0] if h[:destinationchannel] && h[:destinationchannel] =~ /SIP\/\d/
    h
  end
end
