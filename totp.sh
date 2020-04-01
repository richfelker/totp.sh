#!/bin/sh
#
# totp.sh - Shell script implementation of TOTP (RFC 6238)
#
# Copyright © 2020 Rich Felker
#
# Depends on a base32 utility, date command supporting %s format,
# and openssl command line utility. Otherwise portable sh.
#
# Usage: totp.sh < secretfile
#
# where secretfile contains the base32-encoded secret.
#

t=$(($(date +%s)/30))
k="$(tr 0189a-z OLBGA-Z | base32 -d | od -v -An -tx1 | tr -d ' ')"

h=$(
printf '%b' $(printf '\x%.2x' $(
i=0; while test $i -lt 8 ; do
echo $(((t>>(56-8*i))&0xff))
i=$((i+1))
done
)) | openssl dgst -sha1 -mac HMAC -macopt hexkey:"$k" -r | cut -d' ' -f1
)

o=$((0x${h#??????????????????????????????????????}&0xf))
while test $o -gt 0 ; do
h=${h#??}00
o=$((o-1))
done

h=${h%????????????????????????????????}
h=$(((0x$h & 0x7fffffff)%1000000))

printf '%.6d\n' "$h"
