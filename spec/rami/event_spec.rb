require 'spec_helper'
include RAMI

describe Event do
  let :raw_data1 do
    "Event: Cdr\r\nSource: 4303\r\nDestination: 4247\r\n" +
    "Channel: SIP/4301-456aa2\r\n" +
    "StartTime: 2015-06-25 10:33:15\r\n\r\n"
  end

  let :raw_data2 do
    "Event: Cdr\r\nSource: 5551234\r\nDestination: s\r\n" +
    "Channel: SIP/4301-456aa2\r\nDestinationChannel: SIP/4302\r\n" +
    "StartTime: 2015-06-25 10:33:15\r\n\r\n"
  end

  let :incorrect_data do
    "Event:cdrSource:4303Destination:4247"
  end

  let :phone_number do
    '989145551234'
  end

  before { @event = Event.new(raw_data1) }

  context 'parsing with #to_hash' do
    it 'be a Hash' do
      expect(@event.data).to be_a Hash
    end

    it 'have key' do
      expect(@event.data).to have_key('Source')
    end

    it 'have value' do
      expect(@event.data['Source']).to eq '4303'
    end

    it 'incorrect data' do
      expect(Event.new(incorrect_data).data).to eq nil
    end
  end

  context '#set_time' do
    it 'correct' do
      now = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      expect(Event.new.send(:set_time, now).year).to eq Time.now.year
    end

    it 'return nil if string is nil' do
      expect(Event.new.send(:set_time, nil)).to be_nil
    end

    it 'return nil if string is empty' do
      expect(Event.new.send(:set_time, '')).to be_nil
    end
  end

  context '#phone' do
    it 'correct mobile' do
      expect(Event.new.send(:phone, phone_number)).to eq '+79145551234'
    end

    it 'correct other' do
      expect(Event.new.send(:phone, '9555666')).to eq '555666'
    end

    it 'returns nil if phone number is nil' do
      expect(Event.new.send(:phone, nil)).to eq nil
    end

    it 'returns nil if phone number is empty' do
      expect(Event.new.send(:phone, '')).to eq nil
    end
  end

  context 'check fields' do
    before do
      service = class_double('RAMI::Service').as_stubbed_const
      allow(service).to receive(:cfg).and_return({'sourcemask' => '555',
        'passed_calls_mask' => %w(43 44)})
    end

    it '#cdr?' do
      expect(@event.cdr?).to be_truthy
    end

    it '#source' do
      expect(@event.source).to eq '4303'
    end

    it '#source with sourcemask' do
      expect(Event.new(raw_data2).source).to eq '4301'
    end

    it '#destination' do
      expect(@event.destination).to eq '4247'
    end

    it '#destination received at queue' do
      expect(Event.new(raw_data2).destination).to eq '4302'
    end

    it '#fields' do
      expect(@event.fields[:destination]).to eq '4247'
    end
  end

end
