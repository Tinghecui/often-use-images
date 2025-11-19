#!/bin/bash
# 测试workflow功能的脚本

set -e

echo "====== 测试脚本开始 ======"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. 检查Docker是否安装
echo "1. 检查Docker是否安装..."
if command -v docker &> /dev/null; then
    echo -e "${GREEN}✅ Docker已安装${NC}"
    docker --version
else
    echo -e "${RED}❌ Docker未安装${NC}"
    exit 1
fi
echo ""

# 2. 检查是否能连接到Docker Hub
echo "2. 检查Docker Hub连接..."
if docker pull hello-world:latest &> /dev/null; then
    echo -e "${GREEN}✅ 可以连接到Docker Hub${NC}"
    docker rmi hello-world:latest &> /dev/null
else
    echo -e "${RED}❌ 无法连接到Docker Hub${NC}"
    exit 1
fi
echo ""

# 3. 尝试拉取目标镜像（这可能需要很长时间）
echo "3. 测试拉取目标镜像 vllm/vllm-openai:gptoss..."
echo -e "${YELLOW}⚠️  警告：这个镜像可能很大（数GB），拉取可能需要较长时间${NC}"
echo "是否继续测试镜像拉取？(y/n)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    if docker pull vllm/vllm-openai:gptoss; then
        echo -e "${GREEN}✅ 成功拉取镜像 vllm/vllm-openai:gptoss${NC}"
        echo "镜像信息："
        docker images vllm/vllm-openai:gptoss

        # 清理镜像
        echo "清理测试镜像..."
        docker rmi vllm/vllm-openai:gptoss
    else
        echo -e "${RED}❌ 无法拉取镜像 vllm/vllm-openai:gptoss${NC}"
        echo "可能的原因："
        echo "  1. 镜像不存在或已被删除"
        echo "  2. 网络连接问题"
        echo "  3. Docker Hub限流"
    fi
else
    echo "跳过镜像拉取测试"
fi
echo ""

# 4. 检查ACR连接（需要凭证）
echo "4. 检查阿里云ACR连接..."
echo "请输入阿里云用户名（留空跳过）："
read -r aliyun_username
if [ -n "$aliyun_username" ]; then
    echo "请输入阿里云密码："
    read -rs aliyun_password

    if docker login --username="$aliyun_username" --password="$aliyun_password" crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com &> /dev/null; then
        echo -e "${GREEN}✅ 成功连接到阿里云ACR${NC}"
        docker logout crpi-un9cbhka4snaau4v.cn-shanghai.personal.cr.aliyuncs.com &> /dev/null
    else
        echo -e "${RED}❌ 无法连接到阿里云ACR${NC}"
        echo "请检查用户名和密码是否正确"
    fi
else
    echo "跳过ACR连接测试"
fi
echo ""

# 5. 检查GitHub Secrets设置
echo "5. GitHub Secrets检查提示..."
echo "请确保在GitHub仓库设置中已配置以下Secrets："
echo "  - ALIYUN_USERNAME: 阿里云用户名"
echo "  - ALIYUN_PASSWORD: 阿里云Container Registry密码"
echo ""

# 6. 总结
echo "====== 测试完成 ======"
echo ""
echo "下一步操作建议："
echo "1. 确保GitHub Secrets已正确配置"
echo "2. 在GitHub Actions页面手动触发workflow进行完整测试"
echo "3. 查看workflow运行日志，确认是否有错误"
echo ""
