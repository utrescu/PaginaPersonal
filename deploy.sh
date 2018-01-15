#!/bin/bash

echo -e "\033[0;32mEnviant actualitzacions a GitHub...\033[0m"

# Build the project.
hugo -t hyde 


cd public
git add .
msg="rebuilding site `date`"

if [ $# -eq 1 ]
  then msg="$1"
fi

git commit -m "$msg"
git push origin master

cd ..
