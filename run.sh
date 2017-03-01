#!/bin/sh

export LC_ALL=en_US.UTF-8
exec socat -d -v EXEC:'sed -runf ./irc.sed' ${protocol-OPENSSL}:${host-chat.freenode.net}:${port-6697},crnl
