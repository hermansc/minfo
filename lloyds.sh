#!/bin/bash
set -e

usage() {
cat <<EOL
Usage: $0 num1 num2 num3 [passwordfile]
EOL
exit 1;
}

main() {
  # Check that passfile exist
  if [ ! -f "$PASSWORDFILE" ]; then
    echo "File does not exist: $PASSWORDFILE";

    read -p "Do you want to create it? (y/n) " yn;
    case "$yn" in
      [Yy]* ) create_file $1 $2 $3;;
      [Nn]* ) exit;;
      * ) echo "Please answer yes or no.";;
    esac

    exit 1;
  fi

  # Check if it is GPG encrypted
  if [ "$(file -b "$PASSWORDFILE")" == "PGP armored data message" ]; then
    SECRET_WORD=`gpg < "$PASSWORDFILE" | head -n 1`;

    # Ensure that gpg returned sucessfully (we decrypted it)
    if [ $? -ne 0 ]; then
      exit 1;
    fi
  else
    # Read content of first line, as secret word.
    SECRET_WORD=`head -n 1 $PASSWORDFILE`;
  fi

  # Ensure string length is longer than requested chars.
  len=${#SECRET_WORD};
  if [[ $len -lt $1 || $len -lt $2 || $len -lt $3 ]]; then
    echo "Requested number than was higher than string length ($len chars)";
    exit 1;
  fi

  # Ensure requested number is positive
  if [[ $1 -le 0 || $2 -le 0 || $3 -le 0 ]]; then
    echo "Requested number can not be zero or negative";
    exit 1;
  fi

  # Print output
  echo -e "$1\t$2\t$3";
  echo "------------------"
  # Then get the chars.
  out="${SECRET_WORD:$(($1-1)):1}\t";
  out+="${SECRET_WORD:$(($2-1)):1}\t";
  out+="${SECRET_WORD:$(($3-1)):1}";
  echo -e "$out";
}

create_file() {
  # Check if we want to create an encrypted file, or plain one.
  read -p "Encrypted? (y/n) " yn;
  create_memorable_phrase;
  case "$yn" in
    [Yy]* ) create_encrypted $1 $2 $3;;
    [Nn]* ) create_plain $1 $2 $3;;
    * ) echo "Please answer yes or no.";;
  esac
}

create_memorable_phrase() {
  read -s -p "Enter your memorable phrase: " MEMORABLE_PHRASE;
  if [ ${#MEMORABLE_PHRASE} -lt 6 ]; then
    echo "Memorable phrase too short"; exit;
  fi
}

create_plain() {
  echo "$MEMORABLE_PHRASE" > $PASSWORDFILE;

  echo "Created plain password file: $PASSWORDFILE. Running program again.";
  main $1 $2 $3;
}

create_encrypted() {
  echo "$phrase" | gpg -ac --output $PASSWORDFILE;
  # Ensure that gpg returned sucessfully (we encrypted it)
  if [ $? -ne 0 ]; then
    exit 1;
  fi

  echo "Created encrypted password file: $PASSWORDFILE. Running program again.";
  main $1 $2 $3;
}

# Passfile variable, default to .lloyds if not password file is given or it
# does not exist.
PASSWORDFILE="$HOME/.lloyds";
if [ ! -z $4 ]; then
  PASSWORDFILE=$4;
fi

# Some naive checks on arguments.
if [[ $# -lt 3 || $# -gt 4 ]]; then
  usage;
fi

main $1 $2 $3;
