#!/bin/bash
# SYNC REALITY KEYS

REMOTE="root@YOUR.SERVER.IP:/etc/reality/server.key"
LOCAL="/sdcard/nekobox/server.key"
SSH_KEY="/sdcard/ssh/id_rsa"

scp -i "$SSH_KEY" -P 22 "$REMOTE" "$LOCAL"
