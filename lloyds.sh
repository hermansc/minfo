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
    exit 1;
  fi

  # Read content of first line, as secret word.
  read -r SECRET_WORD < $PASSWORDFILE;

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

# Passfile variable.
PASSWORDFILE="$HOME/.lloyds";
if [ ! -z $4 ]; then
  PASSWORDFILE=$4;
fi

if [[ $# -lt 3 || $# -gt 4 ]]; then
  usage;
fi

main $1 $2 $3;
