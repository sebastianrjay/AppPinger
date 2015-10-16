This is a developer tool to ping your Heroku apps during your preferred time
periods. It offers the following advantages over kaffeine.herokuapp.com:

- Logs that tell you if each URL was successfully pinged, or if there was a
server error when the GET request was made.
- Non-continuous pinging periods. kaffeine assumes that you want to ping for 18
hours continuously during a 24-hour period. HerokuAppPinger allows you to ping
over multiple time periods during a 24-hour window.

The only disadvantage over kaffeine.herokuapp.com is that HerokuAppPinger is
slower to set up. If you want greater control over your app and some logs, this
is the way to go.

HerokuAppPinger offers the following advantages over NewRelic:
- Faster setup
- NewRelic continuously pings apps for 24 hours, which triggers Heroku's
automatic shutoff when the app exceeds 18 hours of activity within a 24-hour
window. HerokuAppPinger does not.
- Setting up pinging for multiple apps takes no more time than setup for a
single app.

The disadvantages over NewRelic are that I haven't created a GUI or added email
alerting functionality (yet!) for unsuccessful pinging.


Use and deployment directions:
1. Create an account at [c9.io](c9.io) if you haven't already
2. Create a new workspace. Name it whatever you want. In the field titled,
"Clone from Git or Mercurial URL", paste the HTTPS clone URL listed in the
sidebar at the right of this README. Use the default template, titled "Custom".
3. Once the workspace has been created, run ```bundle install``` in its command
line.
4. Open run.rb and follow the directions inside to create your pingers. Save
your changes.
5. Enter ```ruby run.rb``` in the workspace's command line to run the script and
begin pinging.
