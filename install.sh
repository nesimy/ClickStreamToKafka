export DEBIAN_FRONTEND=noninteractive
echo 'Running apt-get -qq update ...'
apt-get -qq update
echo 'Running apt-get -qq install ...'
apt-get -qq install --no-install-recommends -y \
  wget curl git vim tmux jq mc net-tools less  \
  ca-certificates build-essential locales      \
  librdkafka-dev libev-dev libsnappy-dev zlib1g-dev netcat-traditional
echo 'Downloading Anaconda ...'
wget -qO /opt/Anaconda.sh \
         https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
echo 'Installing Anaconda ...'
cd /opt
bash Anaconda.sh -b -p /opt/anaconda
rm /opt/Anaconda.sh
mv /opt/anaconda/bin/sqlite3 /opt/anaconda/bin/sqlite3.orig
echo 'Installing pykafka ...'
pip install pykafka
echo 'Getting code from GitHub ...'
cd /opt
git clone https://github.com/dserban/ClickStreamToKafka
echo 'Building container, this may take a while ...'

