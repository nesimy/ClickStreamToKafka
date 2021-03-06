export DEBIAN_FRONTEND=noninteractive

echo 'Running apt-get -qq update ...'
apt-get -qq update

echo 'Running apt-get -qq install ...'
apt-get -qq install --no-install-recommends -y \
  wget curl git vim tmux jq mc net-tools less zip unzip tree\
  ca-certificates build-essential locales      \
  libev-dev libsnappy-dev zlib1g-dev netcat-traditional

echo 'installing sdkman'
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
echo 'installing sbt'
sdk install sbt

echo 'Downloading Anaconda ...'
wget -qO /opt/Anaconda.sh \
         https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
echo 'Installing Anaconda ...'
cd /opt
bash Anaconda.sh -b -p /opt/anaconda
rm /opt/Anaconda.sh
mv /opt/anaconda/bin/sqlite3 /opt/anaconda/bin/sqlite3.orig

echo 'Downloading librdkafka ...'
wget -qO /opt/librdkafka.tgz \
         https://github.com/edenhill/librdkafka/archive/v0.11.3.tar.gz
echo 'Extracting librdkafka ...'
tar -xf /opt/librdkafka.tgz -C /opt
rm /opt/librdkafka.tgz
mv /opt/librdkafka* /opt/librdkafka
echo 'Building librdkafka ...'
cd /opt/librdkafka
./configure --prefix=/usr
make
make install
cd /opt
rm -rf /opt/librdkafka

echo 'Installing confluent-kafka ...'
pip install confluent-kafka

echo 'Getting code from GitHub ...'
cd /opt
git clone https://github.com/dserban/ClickStreamToKafka
git clone https://github.com/dserban/flink.git

echo 'installing java...'
apt-get install -y openjdk-8-jdk
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

cd /opt
wget -qO kafka.tgz https://downloads.apache.org/kafka/2.6.0/kafka_2.13-2.6.0.tgz
tar -xzf kafka.tgz
mv /opt/kafka_2.13-2.6.0 /opt/kafka

