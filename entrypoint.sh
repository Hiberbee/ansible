#!/usr/bin/env sh

hostUser=${HOST_USER}
ansibleDirectory=/etc/ansible

# shellcheck disable=SC2039
if [ -f /etc/os-release ]; then
  . "/etc/os-release"
  distribution=$ID
else
  echo "ERROR: I need the file /etc/os-release to determine what my distribution is..."
  exit
fi

echo "Upgrading system packages"
case ${distribution} in
alpine)
  apk add --no-cache --update py3-pip wget python3-dev gcc musl-dev libffi-dev openssl-dev build-base
  pip3 install --upgrade ansible ansible-lint
  rm -rf /var/cache/apk/*
  apk del python3-dev gcc musl-dev libffi-dev openssl-dev build-base
  find /usr/lib/python3.8/site-packages | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf
  ;;
centos | fedora | redhat)
  dnf install -y --refresh python3 python3-pip wget
  pip3 install --upgrade ansible ansible-lint
  find /usr/lib/python3/site-packages | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf
  ;;
arch)
  pacman-key --init
  pacman-key --refresh-keys
  yes | pacman -Syu ansible
  ;;
ubuntu | debian)
  apt-get update
  apt-get install --yes python3-setuptools python3-distutils python3-wheel wget
  wget -qO- https://bootstrap.pypa.io/get-pip.py | python3
  pip3 install --upgrade ansible ansible-lint
  apt-get purge snapd pulseaudio-utils fonts-dejavu-core git python3-setuptools python3-wheel --yes
  apt-get autoremove --yes
  apt-get autoclean --yes
  apt-get clean
  py3clean /usr
  rm -rf ~/.cache/pip/* /var/cache/apt/*
  ;;
*)
  echo "No actions provided for ${distribution}"
  ;;
esac

if [ -d "/mnt/c/Users/${hostUser}/.ssh" ]; then
  echo "Linking ssh keys"
  cp -rf "/mnt/c/Users/${hostUser}/.ssh" "${HOME}/.ssh"
fi

[ -d ${ansibleDirectory} ] || mkdir ${ansibleDirectory}
cd ${ansibleDirectory} || exit

echo "Downloading Ansible roles"
wget "https://github.com/Hiberbee/ansible/archive/master.tar.gz" -qO- | tar xz --strip=1

if [ -f "requirements.yml" ]; then
  echo "Found Galaxy requirements file, installing roles..."
  ansible-galaxy install -r requirements.yml
fi

if [ -f "playbook.yml" ]; then
  echo "Found Ansible playbook, running tasks..."
  ansible-playbook playbook.yml
else
  ansible-playbook "${@}"
fi
