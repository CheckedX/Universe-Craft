#!/bin/bash
# Universe Craft - Coze CLI 导入脚本
# 用法: ./import.sh

set -e

echo "🔮 Universe Craft 导入工具"
echo "=============================="

# 检查 Coze CLI 是否已安装
if ! command -v coze &> /dev/null; then
    echo "❌ Coze CLI 未安装"
    echo "请先安装: curl -fsSL https://www.coze.cn/install.sh | bash"
    exit 1
fi

# 检查登录状态
echo "📡 检查登录状态..."
coze auth status || {
    echo "❌ 未登录，请先运行: coze auth login"
    exit 1
}

# 读取 Skill 内容
SKILL_CONTENT=$(cat "$(dirname "$0")/../SKILL.md")

echo "📦 正在导入 Skill..."

# 创建临时 JSON 文件
cat > /tmp/universe-craft-skill.json << EOF
{
    "name": "universe-craft",
    "description": "小说宇宙构建者 - 根据作品整理世界观，支持故事创作",
    "skill_content": $(echo "$SKILL_CONTENT" | jq -Rs .)
}
EOF

# 调用 Coze CLI 导入
coze skill create --file /tmp/universe-craft-skill.json

echo "✅ 导入成功！"
echo "请在 Coze 控制台查看并发布你的 Skill。"

# 清理
rm -f /tmp/universe-craft-skill.json
