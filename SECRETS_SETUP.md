# GitHub Secrets 配置清单

在使用GitHub Action之前，请确保在仓库设置中添加以下Secrets：

## 必需的Secrets

### 阿里云Container Registry

- **ALIYUN_USERNAME**: 你的阿里云账号全名
- **ALIYUN_PASSWORD**: 你的阿里云Container Registry密码

## 说明

### 关于Docker Hub

本项目拉取的是公开镜像，无需Docker Hub认证。GitHub Actions可以直接拉取公开镜像而不会受到限制。

## 如何设置Secrets

1. 进入GitHub仓库页面
2. 点击 `Settings` 选项卡
3. 在左侧菜单中选择 `Secrets and variables` → `Actions`
4. 点击 `New repository secret` 按钮
5. 输入Secret名称和值
6. 点击 `Add secret` 保存

## 验证配置

配置完成后，可以手动触发GitHub Action来测试配置是否正确。
