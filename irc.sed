#!/bin/sed -runf
# Run like this:
# socat EXEC:./irc.sed TCP:host:port,crnl

1 b boot

: main
# Save away the whole line into the hold-space
h
# Keep only the prefix
s/^:([^ ]*) .*$/\1/
# w /dev/stderr
# Swap hold and pattern space (hold space now has the prefix, pattern space the original string)
x
s/^:[^ ]* //
# Prefix (sender) removed - now saved only in holdspace
#w /dev/stderr

# Match between MOTDSTART and MOTDEND
/^375/,/^376/ {
w motd.txt
}
/^376/ {
i\
PRIVMSG olsner :Hello
}

/^PING/ {
	s/^PING /PONG /p
}

/^PRIVMSG/ {
	G

	/^PRIVMSG +(sedbot +:|[^ ]+ :sedbot[:,] )QUIT\nolsner!.*$/ {
		s/.*/QUIT :I'm done/p
		# Q 0
	}
	# TODO Make a common bit for command messages, so this could be something
	# like /^JOIN/ instead...
	s/^PRIVMSG +(sedbot) +:JOIN (.*)\nolsner!.*$/JOIN \2/p
	s/^PRIVMSG +(sedbot) +:MSG ([^ ]+) (.*)\nolsner!.*$/PRIVMSG \2 :\3/p
	s/^PRIVMSG +([^ ]+) +:sedbot[:,] JOIN (.*)\nolsner!.*$/JOIN \2/p

	# Public commands
	# TODO Simplify to destination and command
	s/^PRIVMSG +(sedbot) +:(.*)\n(.*)!.*$/PRIVMSG \3 :Du kan vara \2/p
	s/^PRIVMSG +([^ ]+) +:sedbot[:,] (.*)\n(.*)!.*$/PRIVMSG \1 :Du kan vara \2/p
}


n
b main

: boot
# First, some setup - set a nick-name
i\
USER sedbot localhost foo :sed IRC bot\
NICK sedbot

b main
