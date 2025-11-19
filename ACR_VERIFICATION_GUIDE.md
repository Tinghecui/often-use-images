# 阿里云 ACR 镜像验证指南

更新时间：2025-11-19
Workflow 运行状态：✅ 成功

---

## 📍 你的 ACR 信息

**Registry 地址：**
```
crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com
```

**镜像完整路径：**
```
crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/ruiyuan2025/gptoss
```

**可用标签：**
- `latest` - 最新版本
- `20251119` - 今天的日期标签

---

## 🌐 方法1：阿里云控制台查看（最简单）

### 访问链接：

**容器镜像服务控制台：**
```
https://cr.console.aliyun.com/
```

**具体导航路径：**
1. 登录阿里云控制台
2. 进入 **容器镜像服务 ACR**
3. 选择 **个人实例** → **上海 (cn-shanghai)**
4. 点击 **仓库列表**
5. 找到命名空间 `ruiyuan2025`
6. 点击仓库 `gptoss`

**在控制台你可以看到：**
- ✅ 镜像标签列表
- ✅ 镜像大小（应该是 ~16.5GB）
- ✅ 推送时间
- ✅ 镜像层信息
- ✅ 安全扫描结果（如果启用）

---

## 💻 方法2：命令行验证

### 步骤1：登录 ACR

```bash
# 登录阿里云 Container Registry
docker login --username=<你的阿里云用户名> \
  crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com

# 输入密码后，应该看到：
# Login Succeeded
```

**注意事项：**
- 用户名通常是你的阿里云账号全名
- 密码是 Container Registry 的独立密码（不是阿里云登录密码）
- 密码可以在 ACR 控制台的"访问凭证"中查看或重置

### 步骤2：拉取镜像

```bash
# 拉取最新版本
docker pull crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/ruiyuan2025/gptoss:latest

# 或者拉取特定日期版本
docker pull crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/ruiyuan2025/gptoss:20251119
```

### 步骤3：验证镜像

```bash
# 查看本地镜像
docker images | grep gptoss

# 应该看到类似输出：
# crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/ruiyuan2025/gptoss   latest    xxx   16.5GB
```

### 步骤4：检查镜像详细信息

```bash
# 查看镜像详细信息
docker inspect crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/ruiyuan2025/gptoss:latest

# 查看镜像历史
docker history crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/ruiyuan2025/gptoss:latest
```

---

## 🧪 方法3：使用 curl 检查镜像元数据

```bash
# 使用 Docker Registry API v2 检查
# 注意：需要先获取认证token

# 1. 获取认证token（需要替换用户名和密码）
TOKEN=$(curl -s -u "<用户名>:<密码>" \
  "https://crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/v2/token?service=registry&scope=repository:ruiyuan2025/gptoss:pull" \
  | python3 -c "import sys, json; print(json.load(sys.stdin)['token'])")

# 2. 查看所有标签
curl -s -H "Authorization: Bearer $TOKEN" \
  "https://crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/v2/ruiyuan2025/gptoss/tags/list" \
  | python3 -m json.tool

# 3. 获取镜像 manifest
curl -s -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
  "https://crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/v2/ruiyuan2025/gptoss/manifests/latest" \
  | python3 -m json.tool
```

---

## 🚀 方法4：测试运行镜像

```bash
# 运行镜像（根据你的具体用途）
docker run --rm \
  crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/ruiyuan2025/gptoss:latest \
  --help

# 或者启动交互式容器
docker run -it --rm \
  crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/ruiyuan2025/gptoss:latest \
  /bin/bash

# 如果是 vllm 服务，可能需要运行类似：
docker run -d \
  --gpus all \
  -p 8000:8000 \
  crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/ruiyuan2025/gptoss:latest
```

---

## 📊 验证清单

使用这个清单确认镜像已成功同步：

### 在阿里云控制台
- [ ] 能看到 `ruiyuan2025` 命名空间
- [ ] 能看到 `gptoss` 仓库
- [ ] 能看到 `latest` 标签
- [ ] 能看到 `20251119` 标签
- [ ] 镜像大小约为 16.5GB
- [ ] 推送时间是今天

### 在命令行
- [ ] 能成功登录 ACR
- [ ] 能成功拉取镜像
- [ ] 镜像大小正确
- [ ] 能运行镜像

---

## 🔗 重要链接

### 阿里云控制台
- **容器镜像服务首页：** https://cr.console.aliyun.com/
- **个人实例列表：** https://cr.console.aliyun.com/cn-shanghai/instances
- **访问凭证（重置密码）：** https://cr.console.aliyun.com/cn-shanghai/instances/credentials

### 镜像信息
- **Registry：** `crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com`
- **命名空间：** `ruiyuan2025`
- **仓库名：** `gptoss`
- **区域：** 上海 (cn-shanghai)

### GitHub Actions
- **最新运行：** https://github.com/Tinghecui/often-use-images/actions/runs/19503157077
- **所有运行记录：** https://github.com/Tinghecui/often-use-images/actions

---

## 🌍 内网访问（VPC环境）

如果你在阿里云 VPC 网络环境中，使用内网地址可以获得更快的速度：

**内网 Registry 地址：**
```
crpi-un9cbhka4snaau4v-vpc.cn-shanghai.personal.cr.aliyuncs.com
```

**内网拉取命令：**
```bash
# 登录内网地址
docker login --username=<你的用户名> \
  crpi-un9cbhka4snaau4v-vpc.cn-shanghai.personal.cr.aliyuncs.com

# 拉取镜像
docker pull crpi-un9cbhka4snaau4v-vpc.cn-shanghai.personal.cr.aliyuncs.com/ruiyuan2025/gptoss:latest
```

---

## ⚙️ 在其他机器上使用镜像

### Docker Compose 示例

```yaml
version: '3.8'
services:
  vllm:
    image: crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/ruiyuan2025/gptoss:latest
    ports:
      - "8000:8000"
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
```

### Kubernetes 示例

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vllm-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: vllm
  template:
    metadata:
      labels:
        app: vllm
    spec:
      containers:
      - name: vllm
        image: crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/ruiyuan2025/gptoss:latest
        ports:
        - containerPort: 8000
      imagePullSecrets:
      - name: aliyun-acr-secret
```

**创建 ImagePullSecret：**
```bash
kubectl create secret docker-registry aliyun-acr-secret \
  --docker-server=crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com \
  --docker-username=<你的用户名> \
  --docker-password=<你的密码> \
  --docker-email=<你的邮箱>
```

---

## 🔍 故障排除

### 问题1：登录失败
```
Error response from daemon: login attempt to ... failed with status: 401 Unauthorized
```

**解决方案：**
1. 检查用户名是否正确（通常是阿里云账号全名）
2. 确认使用的是 Container Registry 密码，不是阿里云登录密码
3. 在 ACR 控制台重置密码

### 问题2：拉取失败
```
Error response from daemon: manifest for xxx not found
```

**解决方案：**
1. 检查镜像名称和标签是否正确
2. 在 ACR 控制台确认镜像存在
3. 确认已登录正确的 registry

### 问题3：网络慢
```
拉取速度很慢
```

**解决方案：**
1. 如果在阿里云 VPC 内，使用内网地址（带 `-vpc` 后缀）
2. 检查网络带宽
3. 考虑使用阿里云的镜像加速器

---

## 📝 后续维护

### 定期同步（可选）

如果想要自动定期同步，可以在 workflow 中添加定时触发：

```yaml
on:
  push:
    branches: [ main ]
  workflow_dispatch:
  schedule:
    - cron: '0 2 * * 0'  # 每周日凌晨2点
```

### 监控镜像更新

可以订阅 Docker Hub 的 webhook 或使用工具监控上游镜像更新。

---

## 🎉 成功验证示例

如果一切正常，你应该看到类似输出：

```bash
$ docker login --username=xxx crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com
Password:
Login Succeeded

$ docker pull crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/ruiyuan2025/gptoss:latest
latest: Pulling from ruiyuan2025/gptoss
...
Status: Downloaded newer image for crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/ruiyuan2025/gptoss:latest

$ docker images | grep gptoss
crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/ruiyuan2025/gptoss   latest    abc123def456   16.5GB
crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/ruiyuan2025/gptoss   20251119  abc123def456   16.5GB
```

---

*验证指南生成时间：2025-11-19*
*Workflow 状态：✅ 成功*
*镜像大小：16.5GB*
