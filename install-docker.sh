if ! docker --version ; then 
  # Install docker as told in: https://docs.docker.com/engine/install/debian/
  sudo apt-get update
  sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release

  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io
  docker --version
else
  echo "Docker already installed"
fi

if ! docker-compose --version ; then
  # Install docker-compose as told in https://docs.docker.com/compose/install/
  sudo curl -L "https://github.com/docker/compose/releases/download/1.28.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  docker-compose --version
else
  echo "Docker-compose already installed"
fi
