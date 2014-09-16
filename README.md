## Lloyds Internet Banking - Memorable information helper

Helps you, via the command prompt, easily find the characters in your secret
"memorable information" needed to log into the Lloyds online bank.

### Usage

    $ echo "mysecretword" > ~/.lloyds
    $ chmod 700 ~/.lloyds
    $ lloyds 3 4 10
    3     4     10
    --------------
    s     e      o

You can also invoke it by specifying the path:

    $ lloyds 3 4 10 ~/.lloyds

### Install

Just download the .sh script, and place it e.g. in your home directory. Then
symlink it:

    $ ln -s ~/lloyds.sh /usr/local/bin/lloyds

Or whatever solution you prefer.
