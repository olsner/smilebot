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
#i\
#PRIVMSG olsner :Hello
}

/^PING/ {
	s/^PING /PONG /p
}

/^PRIVMSG/ {
	G

	/^PRIVMSG +(smilebot +:|[^ ]+ :smilebot[:,] )QUIT\nolsner!.*$/ {
		s/.*/QUIT :I'm done/p
		# Q 0
	}
	# TODO Make a common bit for command messages, so this could be something
	# like /^JOIN/ instead...
	s/^PRIVMSG +(smilebot) +:JOIN (.*)\nolsner!.*$/JOIN \2/p
	s/^PRIVMSG +(smilebot) +:PART (.*)\nolsner!.*$/PART \2/p

	s/^PRIVMSG +([^ ]+) +:smilebot[:,] JOIN (.*)\nolsner!.*$/JOIN \2/p
	s/^PRIVMSG +([^ ]+) +:smilebot[:,] PART (.*)\nolsner!.*$/PART \2/p

	s/^PRIVMSG +(smilebot) +:MSG ([^ ]+) (.*)\nolsner!.*$/PRIVMSG \2 :\3/p

	/^PRIVMSG +[^ ]+ ::D\n/d
	#s/^PRIVMSG +([^ ]+) [^\n]*\n(.*)$/MODE \2 +b \1 ::D/p
	s/^PRIVMSG +([^ ]+) [^\n]*\n([^!]*)!.*$/KICK \1 \2 ::D/p
}


n
b main

: boot
# First, some setup - set a nick-name
i\
USER smilebot localhost foo :Don't worry, be happy\
NICK smilebot\
JOIN #osdev-offtopic/:D

b main
