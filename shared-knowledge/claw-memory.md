# MEMORY.md - 跨会话记忆

## 用户偏好
- 中文交流，偏好结构化输出（表格）
- 做事谨慎，会先了解清楚再做决定
- 有明确会话收尾习惯
- 公司：腾讯/阶跃星辰
- 使用模型偏好：DeepSeek（已充值 10 元）

## 云服务器（腾讯云）
- IP：124.223.110.120，用户：ubuntu
- OS：Ubuntu 24.04 LTS，月包试用
- OpenClaw：v2026.5.28
- 服务：systemd 托管，开机自启，EnvironmentFile 加载 .env
- API key：~/.openclaw/.env（chattr +i 不可变）
- 模型：deepseek/deepseek-chat → fallback: dashscope/qwen-max
- 渠道：钉钉 ✅ | 微信 ❌（OpenClaw bug #68451 未修复）

## 本地 OpenClaw
- 全局安装：openclaw v2026.5.19（`npm install -g openclaw`）
- 微信插件：@tencent-weixin/openclaw-weixin v2.4.3（已扫码认证，凭证保存）
- 配置目录：`~/.openclaw/`（Gateway 读），`~/.stepclaw/`（桌面端读）

## 已知问题
- StepClaw 桌面端 v0.3.15 与云服务器 WebSocket 协议不匹配
- dmPolicy=pairing 在云服务器版 OpenClaw 不支持（DingTalk）
- **云端微信不可用：OpenClaw #68451**（Gateway 拒绝加载 openclaw-weixin channel）
- 微信本地可用：通过本地 OpenClaw + ilinkai 扫码认证
- 凭证文件路径：`~/.openclaw/openclaw-weixin/accounts/`
- 元宝 Claw 依赖 WorkBuddy 桌面桥接，无法 24h 独立运行

## 钉钉 Claw 自我成长体系
- **已有体系**：云服务器 scripts/ 目录下有完整的自成长脚本（daily-summary、self-sediment、self-reflection、idea-pool 等）
- **lessons 仓库**：`.lessons/` 已积累 11+ 个 lessons（auto-detected + 手动）
- **新部署**：lesson-detector.py + lesson-auto-apply.sh + pattern-threshold.sh
- **cron**：每 30 分钟检测/自动应用，每小时 pattern 检测
- **记录**：`.behavior-log.md` 跟踪所有 self-growth 事件
- **lesson-detector**：从 MEMORY.md 关键词自动检测 6 种常见场景（配置错误/插件异常/对话卡死/同步冲突/授权失效/协议不匹配）

## 待办
- [ ] 云服务器到期前迁移到年包（阿里云 38/99元/年）
- [ ] StepClaw 桌面端修复（等版本升级）
- [x] env.conf — 已废弃，由 .env + EnvironmentFile 覆盖
- [ ] 等 OpenClaw 修复 #68451 后重试云端微信
