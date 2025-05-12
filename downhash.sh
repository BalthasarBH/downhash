#!/bin/sh

echo "\nWelcome to my download & hash script!\n"

read -p "Please enter the download URL: " url

read -p "Please enter the SHA256-Hash: " expected_hash

filename=$(basename "$url")

echo "Downloading file..."
curl -L -o "$filename" "$url"

if [[ ! -f "$filename" ]]; then
  echo "Failed downloading file. Exiting."
  exit 1
fi

echo "Calculating SHA256-Hash..."
calculated_hash=$(sha256sum "$filename" | awk '{ print $1 }')

if [[ "$calculated_hash" == "$expected_hash" ]]; then
  echo "The SHA256-Hash matches."
else
  echo "\nThe SHA256-Hash do not match.\n"
  echo "Expected:   $expected_hash"
  echo "Calculated: $calculated_hash"
  echo "Mark file as 'broken'..."

  new_filename="BROKEN_$filename"

  mv "$filename" "$new_filename"

  echo "\nFile is now marked as $new_filename !\nExiting..."
  exit 2
fi
