#!/bin/sh

exec socat -d -v EXEC:'sed -runf ./irc.sed' OPENSSL:chat.freenode.net:6697,crnl
