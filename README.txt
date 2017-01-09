
Now you should be able to do:

$ docker-compose build
$ docker-compose up

All images should work, except zoe-agent-shell, that fails
with a message like 'Not in a TTY, exiting...'
This is because the shell is intended to work interactively.
In order to use it, do in other terminal:

$ docker-compose run zoe-agent-shell

You should see a welcome message. Type:

email(user('someone'), 'subject', 'body')

Two things should happen:

- The shell responds with a confirmation message
- A bunch of messages should appear in the log, 
  showing the messages interchanged.

