# 常用镜像同步工具

这个仓库使用GitHub Actions自动从Docker Hub拉取常用镜像并同步到阿里云Container Registry。

## 当前同步的镜像

- `vllm/vllm-openai:gptoss` → `crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/ruiyuan2025/gptoss`

## 配置说明

### 1. 设置GitHub Secrets

在GitHub仓库设置中添加以下Secrets：

#### 阿里云Container Registry认证（必需）

- `ALIYUN_USERNAME`: 你的阿里云账号全名
- `ALIYUN_PASSWORD`: 阿里云Container Registry密码

### 2. 设置Secrets的步骤

1. 进入GitHub仓库页面
2. 点击 `Settings` → `Secrets and variables` → `Actions`
3. 点击 `New repository secret`
4. 添加上述2个secrets

### 3. 运行方式

#### 自动运行

- 推送到main分支时运行

#### 手动运行

1. 进入GitHub仓库的Actions页面
2. 选择 "Sync Docker Image to Aliyun" 工作流
3. 点击 "Run workflow" 按钮

## 镜像标签说明

同步的镜像会打上两个标签：

- `latest`: 最新版本
- `YYYYMMDD`: 日期标签，如 `20250818`

## 使用同步后的镜像

```bash
# 拉取最新版本
docker pull crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/ruiyuan2025/gptoss:latest

# 拉取特定日期版本
docker pull crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com/ruiyuan2025/gptoss:20250818
```

## 阿里云登录命令

```bash
# 登录阿里云Container Registry
docker login --username=<你的用户名> crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com

# 如果在VPC网络环境中，使用内网地址
docker login --username=<你的用户名> crpi-un9cbhka4snaau4v-vpc.cn-shanghai.personal.cr.aliyuncs.com
```

## 添加新镜像

要添加新的镜像同步，编辑 `.github/workflows/sync-docker-image.yml` 文件，在现有步骤后添加新的拉取、标记和推送步骤。

## 故障排除

1. **认证失败**: 检查GitHub Secrets是否正确设置
2. **镜像拉取失败**: 检查源镜像名称是否正确
3. **推送失败**: 检查阿里云仓库权限和网络连接

## 监控

可以在GitHub Actions页面查看每次同步的详细日志和状态。
