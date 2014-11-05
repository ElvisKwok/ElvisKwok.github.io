#! /bin/sh

echo -n "input message: "
read message

git add .
git commit -m "$message"
git push
