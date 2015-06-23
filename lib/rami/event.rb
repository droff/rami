module RAMI
  class Event
    SEPARATOR_EVENTS = "\r\n\r\n"
    SEPARATOR_FIELDS = "\r\n"

    def initialize(raw_data)
      @data = to_hash(raw_data.split(SEPARATOR_EVENTS))
    end

    def cdr?
      @data['Event'] == 'Cdr' ? true : false
    end

    def source
      src = case @data['Source']
        when /#{Service.cfg['sourcemask']}/
          get_match(/\d{4}/, @data['Channel'])
        else
          @data['Source']
        end

      phone(src)
    end

    def destination
      dst = case @data['Destination']
        when 's'
          get_match(/\d{4}/, @data['DestinationChannel'])
        when 'start'
          get_match(/\+\d{11}/, @data['LastData'])
        else
          @data['Destination']
        end

      phone(dst)
    end

    def starttime
      set_time(@data['StartTime'])
    end

    def answertime
      set_time(@data['AnswerTime'])
    end

    def endtime
      set_time(@data['EndTime'])
    end

    def billableseconds
      @data['BillableSeconds']
    end

    def disposition
      @data['Disposition']
    end

    def passed?(phone)
      m = /^(#{Service.cfg['passed_calls_mask'].join('|')})\d{2}$/
      phone =~ m ? true : false
    end

    def to_s
      fields.map { |field, value| "#{field}: #{value}" }.join("\n")
    end

    def fields
      {
        source: source,
        destination: destination,
        starttime: starttime,
        answertime: answertime,
        endtime: endtime,
        billableseconds: billableseconds,
        disposition: disposition
      }
    end

    private

    def to_hash(arr)
      raw_fields = arr.map { |str| str.split(SEPARATOR_FIELDS) }.flatten
      fields_arr = raw_fields.map do |str|
        field, value = str.split(': ')
        value ||= ''
        [field, value]
      end

      Hash[*fields_arr.flatten]
    end

    def get_match(reg, str)
      m = reg.match(str)
      m.nil? ? '' : m[0]
    end

    def set_time(str)
      str.empty? ? nil : Time.parse(str)
    end

    def phone(str)
      str[0] = ''   if str[0] == '9'
      str[0] = '+7' if str[0] == '8'
      str[0] = '+7' if str[0] == '7'
      str
    end
  end
end