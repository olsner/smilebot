#!/bin/sh

export LC_ALL=en_US.UTF-8
exec socat -d -v EXEC:'sed -runf ./irc.sed' OPENSSL:chat.freenode.net:6697,crnl
