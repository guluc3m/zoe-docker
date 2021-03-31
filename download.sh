#!/bin/bash

# Download Zoe agents
AGENTS="zoe-agent-mail zoe-agent-msglog zoe-agent-user zoe-agent-shell"

for i in $AGENTS
do
  if [ -d $i ]
  then
    pushd $i
    git pull origin master
    popd
  else
    git clone https://github.com/guluc3m/$i.git
  fi
done

echo
echo All subprojects downloaded. Take a look at README files to launch your Zoe instance.
echo

