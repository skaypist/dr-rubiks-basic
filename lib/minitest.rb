module Minitest
  class Test
    @@test_classes = []

    def self.inherited(sub)
      self.test_classes.push sub
    end

    def self.test_classes
      @@test_classes
    end

    def humanize_snake str
      str.split('_').map(&:capitalize).join(" ").strip
    end

    def humanize_camel str
      # str.ch
      words = str.chars.inject([]) do |words, char|
        words.push "" if char.capitalize == char
        words[-1] = "#{words.last}#{char.downcase}"
        words
      end
      snakified = words.join("_")
      humanize_snake(snakified)
    end

    def pad(str, len)
      (str + ' ' * len)[0,len]
    end

    def describe_test
      puts humanize_camel(self.class.name)
    end

    def describe_spec(test_method, elapsed = "N/A")
      entry_name = "  - #{humanize_snake(test_method.to_s[5..-1].to_s)}"
      with_time = pad(entry_name, 60)+" #{elapsed}"
      puts with_time
    end

    def run
      describe_test
      methods(false).each do |m|
        if m.to_s[0..4] == "test_"
          starting = Time.now
          send(m)
          ending = Time.now
          describe_spec(m, "#{ending - starting}")
        end
      end
    end

    def message(msg = nil, ending = ".", &default)
      proc {
        msg = msg.call.chomp(".") if Proc === msg
        custom_message = "#{msg}.\n" unless msg.nil? or msg.to_s.empty?
        "#{custom_message}#{default.call}#{ending}"
      }
    end

    def assert_equal(exp, act, msg = nil)
      msg = message(msg, "") do
        puts "expected"
        puts exp.inspect

        puts "actual"
        puts act.inspect
      end
      assert exp == act, msg
    end

    def assert test, msg = nil
      msg ||= "Failed assertion, no message given."
      unless test
        msg = msg.call if Proc === msg
        raise msg
      end
      true
    end
  end

  def self.run
    Test.test_classes.each do |test_klass|
      puts "-------"
      test_klass.new.run
    end
  end
end
