# totp.sh

This is a simple shell script implementation of TOTP (RFC 6238).
It depends only on a base32 utility, date command supporting %s format,
and openssl command line utility.

## Usage

    totp.sh < secretfile

where secretfile contains the base32-encoded secret.
