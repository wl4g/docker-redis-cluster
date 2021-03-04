## docker-redis-cluster
A simple redis5.0 cluster



### Quick Start

```
mkdir -p /mnt/disk1/redis

docker run -itd \
-p 16379:16379/tcp \
-p 16380:16380/tcp \
-p 16381:16381/tcp \
-p 17379:17379/tcp \
-p 17380:17380/tcp \
-p 17381:17381/tcp \
-p 6379:6379/tcp \
-p 6380:6380/tcp \
-p 6381:6381/tcp \
-p 7379:7379/tcp \
-p 7380:7380/tcp \
-p 7381:7381/tcp \
-v /mnt/disk1/redis/:/mnt/disk1/redis/ \
--privileged \
--name=redis-cluster \
wl4g/redis-cluster:latest -XlistenIp='127.0.0.1'  -XredisPassword='123456'
```

### FAQ
- How to configure fast image in China?
```
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://hjbu3ivg.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```
Notes:
- 1. When pulling, the image name (wl4g / redis) will be changed- cluster:latest ）Change to: registry.cn-shenzhen.aliyuncs.com/wl4g/redis-cluster:latest
- 2. If it's a VPC machine from Alibaba, it can fly faster through the VPC intranet (limited to South China 1): registry-vpc.cn-shenzhen.aliyuncs.com/wl4g/redis-cluster:latest

