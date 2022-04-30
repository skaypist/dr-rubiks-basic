# require 'app/require_tests.rb'
# require 'app/tick.rb'

# For advanced users:
# You can put some quick verification tests here, any method
# that starts with the `test_` will be run when you save this file.

# Here is an example test and game

# To run the test: ./dragonruby mygame --eval app/require_tests.rb --no-tick
# To run the test: smaug run --eval app/require_tests.rb --no-tick

class AppTest
  def perform_tick(args)
    Minitest.run if args.tick_count == 1
    args.gtk.request_quit if args.tick_count > 1
  end
end
