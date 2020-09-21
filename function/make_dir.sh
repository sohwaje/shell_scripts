#!/bin/sh
make_home_dir()
{
if [[ -d /home/${1} ]];then
  echo "/home/${1} directory does exist. Back up and recreate $1"
  sudo mv /home/${1} /home/${1}-${date_}
  sudo mkdir -p /home/${1} && sudo chmod 0755 /home/${1}
else
  echo -e "\e[0;31;47m /home/${1} directory does not exist. Create ${1} directory\e[0m"
  sudo mkdir -p /home/${1} && sudo chmod 0755 /home/${1}
fi
}

# usage
make_dir Test
