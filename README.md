This is a script to locally ping your Heroku apps during your preferred time
periods, to prevent them from sleeping. It can be deployed on a server or run
locally.

To use it, first configure run.rb as described in the commented directions.

Then navigate to the root directory and enter ```ruby run.rb``` to begin
pinging. It prints logs to notify you if and when each URL was successfully
pinged, and prints GET response error messages without halting pinging.

My previous README included directions for deploying the script at c9.io in
order to ping the apps continually. Unfortunately this doesn't work, as c9.io
closes every terminal session when you close the tab containing your workspace.

I may build this into a Rails app similar to kaffeine.herokuapp.com, or write
a new set of directions for a different cloud deployment option.
