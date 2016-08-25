#!/bin/sh

socat -d -d EXEC:./irc.sed OPENSSL:chat.freenode.net:6697,crnl
