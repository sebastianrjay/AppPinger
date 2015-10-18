# Do not delete or comment this line:
require_relative 'lib/heroku_app_pinger.rb'

# Instantiate and run your app pingers in this file.
#
# NOTE: all times must be written as 00:00 - 23:59, and are automatically
# converted to UTC
#
# Examples:
#
# urls1 = [
# "google.com",
# "yahoo.com",
# "bbc.co.uk"
# ]
#
# urls2 = [
# "reddit.com",
# "facebook.com",
# "humansofnewyork.com",
# "netflix.com"
# ]
#
# url3 = "theonion.com"
# url4 = "en.wikipedia.org"
#
# HerokuAppPinger.new(urls1, "5:30").run
# HerokuAppPinger.new(urls2, "6:30", 23).run
# HerokuAppPinger.new(url3, "5:08").run
# HerokuAppPinger.new(url4, 23).run
