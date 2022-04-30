def tick args
  $app ||= for_mode(args)
  $app.perform_tick(args)
end

def for_mode(args)
  if args.gtk.argv.end_with?("--specs")
    AppTest.new
  else
    App.new
  end
end