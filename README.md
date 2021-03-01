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

### Notes:
> 国内的朋友推荐使用阿里云镜像加速(>=1.10.0), 修改配置文件/etc/docker/daemon.json
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
- pull的时候将镜像名(wl4g/redis-cluster:latest)改为: registry.cn-shenzhen.aliyuncs.com/wl4g/redis-cluster:latest
- 如果是阿里vpc的机器, 走vpc内网更快地飞起来(限华南1): registry-vpc.cn-shenzhen.aliyuncs.com/wl4g/redis-cluster:latest
