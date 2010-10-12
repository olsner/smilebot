#!/bin/sed -runf

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
# w /dev/stderr

# Match between MOTDSTART and MOTDEND
/^375/,/^376/ {
w motd.txt
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
	s/^PRIVMSG +(sedbot +:|[^ ]+ +:?sedbot[:,] )JOIN (.*)\nolsner!.*$/JOIN \2/p
	s/^PRIVMSG +(sedbot +:|[^ ]+ +:?sedbot[:,] )(.*)\n(.*)!.*$/PRIVMSG \3 :Du kan vara \2/p

}


n
b main

: boot
# First, some setup - set a nick-name
i\
USER sedbot localhost foo :sed IRC bot\
NICK sedbot

b main