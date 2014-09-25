## Lloyds Internet Banking
### Memorable information utility

Helps you, via the command prompt, easily find the characters in your secret
"memorable information" needed to log into the Lloyds online bank.

At first run you save your memorable information as a plain text file or
encrypt it with PGP, enabling you to query that file for characters at certain
places in the word. If encrypted it will ask you for a password, before
querying.

### Usage

    $ lloyds 3 6 9
    File does not exist: ~/.lloyds
    Do you want to create it? (y/n) y
    Encrypted? (y/n) y
    Enter your memorable phrase: foobarfoo
    Enter your passphrase: ****
    Repeat passphrase: ****
    Created encrypted password file: ~/.lloyds. Running program again.
    Enter passphrase: ****
    3     6      9
    --------------
    o     r      o

    $ lloyds 3 6 9
    Enter passphrase: ****
    3     6      9
    --------------
    o     r      o

You can also invoke it by specifying the path:

    $ lloyds 3 4 10 ~/.lloyds

### Install

Just download the .sh script, and place it e.g. in your home directory. Then
symlink it:

    $ ln -s ~/lloyds.sh /usr/local/bin/lloyds

Or whatever solution you prefer.
