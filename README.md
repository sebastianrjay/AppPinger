This is a developer tool to ping your Heroku apps during your preferred time
periods. It offers the following advantages over kaffeine.herokuapp.com:

- You can stop pinging your app if you want to, or change when it's pinged!
- Logs that tell you if each URL was successfully pinged, or if there was a
server error when the GET request was made.
- Non-continuous pinging periods. kaffeine assumes that you want to ping for 18
hours continuously during a 24-hour period. HerokuAppPinger allows you to ping
over multiple time periods during a 24-hour window.

The only disadvantage over kaffeine.herokuapp.com is that HerokuAppPinger is
slower to set up. If you want greater control over your app and some logs, this
is the way to go.

HerokuAppPinger offers the following advantages over NewRelic:
- NewRelic continuously pings apps for 24 hours, which triggers Heroku's
automatic shutoff when the app exceeds 18 hours of activity within a 24-hour
window.
- Setting up pinging for multiple apps takes no more time than setup for a
single app.

The disadvantages over NewRelic are that I haven't created a GUI or added email
alerting functionality (yet!) for unsuccessful pinging.


Use and [c9.io](c9.io) cloud deployment directions coming soon!
