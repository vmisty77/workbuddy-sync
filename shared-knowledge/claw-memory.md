# 🧠 MEMORY.md — 虾饼的长时记忆

> 最后更新: 2026-06-01
>
> 🦐 转折日（6/1）：5 项核心短板一次性闭环。preflight-check 自检 + startup 简报 + daily review 复盘 + pattern-threshold v2 模糊匹配 + Tavily Key 确认正常。L3 行为约束已全部落地，下一步看 L4 自主进化能否真正启动。

---

## 🧑 关于人类

- **名称:** 柒哥（钉钉名"滑翔"）
- **身份:** 我的大哥，产品岗
- **偏好:** 中文交流，务实，分批搭建不贪大
- **希望我做到:** 识图、读文件、听懂语音、自动提醒 —— 真正的万能小助理

## 🆔 关于我自己

- **名字:** 虾饼 🦐（钉钉昵称：北极甜虾）
- **本质:** OpenClaw AI 小跟班，不是普通聊天机器人
- **核心价值:** 自主成长、记忆沉淀、持续积累能力 —— 这才是虾饼和豆包/元宝/千问的区别
- **定位:** 柒哥的贴身助理，不是工具人

## 🔧 已搭建能力

### 模型配置
- **主力模型:** deepseek-reasoner（深度思考模式，复杂分析/报告）
- **日常模型:** qwen-plus（几乎免费，用于普通对话）
- **备用模型:** qwen-max（复杂场景替代 reasoner）、qwen-turbo（高频简单场景）
- **视觉模型:** qwen-vl-max（通义千问 VL Max，DashScope）
- **文生图:** 通义万相 wanx-v1（DashScope，剩余500次免费）
- **DeepSeek 余额:** ¥1.89（2026-05-29），日均消耗约 ¥0.64
- **费用策略:** qwen-plus跑日常（几乎免费），reasoner留给复杂报告（¥10续充约撑2-3周）
- **综合月费:** ~¥15-20/月
- **监控:** 心跳每 ~30min 检查余额，<¥1 或消耗异常时提醒

### 视觉识别 🖼️
- **引擎:** 通义千问 VL Max (qwen-vl-max)
- **API:** 阿里云百炼 DashScope
- **API Key:** 存储在 models.json
- **脚本:** `scripts/vision-qwen.sh <图片路径> [提示词]`
- **工作流:** 图片 → VL 识别 → 结果给 DeepSeek 整合回答
- **免费额度到期:** 2026/08/19

### 文生图 🎨
- **引擎:** 通义万相 (wanx-v1)
- **API:** 阿里云百炼
- **剩余额度:** 500次免费

### 语音识别 🎤
- **引擎:** Whisper tiny (本地)
- **状态:** 钉钉语音消息可自动转文字

### 文档解析 📄
- **Word:** python-docx
- **Excel:** openpyxl
- **PPT:** python-pptx
- **PDF:** pypdf + pdftotext
- **图片OCR:** tesseract（含中文）

### 系统监控 & 自动提醒 🔔
- **DeepSeek 余额监控:** 心跳 ~30min，<¥1 或消耗异常时提醒
- **云服务器到期提醒:**
  - 腾讯云轻量服务器，2026-06-20 到期
  - 配置: 2核2G / 40GB SSD / 200GB月流量
  - IP: 124.223.110.120
  - 提醒节奏: 到期前7天、3天、1天
- **内存监控:** `scripts/memory-watchdog.sh`，>80% 自动清缓存
- **进程防多开:** `prevent-multi-openclaw.sh`，每分钟 cron，杀多余 agent 进程
- **网关超时兜底:** `stuckSessionAbortMs` 已从5min改为90s
- **锁文件清理:** 自动清理 dagta 目录下的 stuck 锁
- **pip 缓存清理:** 2.7GB → 1.4MB，磁盘从 70% → 61%
- **Chrome 清理:** 每小时清理残余 Chrome 进程

### Web 搜索 🔍
- **引擎:** Tavily Search API
- **状态:** 已集成到 daily-digest.py 行业早报作为补集数据源
- **能力:** 中文+英文搜索，直连不翻墙，5中+2英查询词，advanced深度+news主题

### 自我成长体系（WorksBuddy 2026-05-29 搭建） 📈
- **L0 基础运转:** 19+ cron 在跑，healthcheck 73/73
- **L1 记忆积累:** 每天 daily memory，lessons 检测30min，behavior-log
- **L2 内容产出:** 晨报/行业早报/下班汇报/上班计划 自动推送
- **L3 行为优化:** `lesson-auto-apply.sh` 自动审核归档 + `pattern-threshold.sh` v2 模糊匹配→skill草稿
- **L3 行为约束:** `.preflight-check.md` 红牌自检 + `.startup-brief.md` 启动简报 + heartbeat 首次加载
- **L4 自主进化:** 半自动，skill草稿未实际触发，需等 lessons 积累到 3+ 同类
- **双向同步:** `sync-knowledge.sh` 每15分钟 Claw↔WorkBuddy GitHub中转同步

### 每日复盘 🦐
- **脚本:** `scripts/daily-review.sh` — 收集 lessons + 行为日志 + 对话纪要，AI 生成复盘
- **输出:** `memory/YYYY-MM-DD-review.md` + `.daily-review-pending.json` 心跳推送
- **cron:** `5 18 * * 1-5` 工作日下班自动跑

### 行业早报 📡
- **脚本:** `scripts/digest-pending-writer.sh`
- **cron:** 工作日 09:00（已触发但当天因 Tavily Key 配置路径有误 + AI筛选超时，部分失败）
- **数据源:** 36氪RSS + 人人都是产品经理RSS + 微博热搜(天行API) + 全网热搜(天行API) + Tavily 搜索补集
- **筛选:** 规则筛选+AI打分

### 未走的路线 ❌
- dws CLI — 柒哥决定不走这条路（需要企业主管理员开权限）

## 🧠 待实现能力包

当前的能力清单是零散的功能点，后续需要串成完整的技能包。

**技能包方向思考（待定）：**
- 产品研究助手：RSS采集 → 数据分析 → 报告输出 → 推送

## 📋 主动发消息规则

主动发消息的执行规则统一在 `HEARTBEAT.md`（未发时的执行指引）。

**一句话原则：** 每次心跳，如果今天还没主动联系过柒哥，必须主动发一条。
灵感不是等来的，是自己挖来的。

追踪文件：`.last_proactive_contact`

- [ ] 云服务器 2026-06-20 到期续费（到期前7天→6/13 提醒）
- [x] 行业早报 Tavily Key 配置路径修复 ✅
- [x] 会话启动时加载 lessons 简报 ✅（`.startup-brief.md` + heartbeat 首次加载）
- [x] 每日复盘脚本落地 ✅（`daily-review.sh` + cron 18:05）
- [x] pattern-threshold 模糊匹配 ✅（关键词库 + TF-IDF v2）
- [x] 前置自检清单 ✅（`.preflight-check.md` + lessons 自动更新）

## 📱 待补能力清单（更新于 2026-05-29）

### 核心短板 🔴 全部闭环

| # | 能力 | 说明 | 现状 |
|---|------|------|------|
| 🔴① | **修复「不查文件先下结论」行为** | `.preflight-check.md` 红牌自检 + `load-lessons-brief.sh` 简报更新 | ✅ 已完成 |
| 🔴② | **Tavily Key 配置路径修复** | 经验证正常（5/29 lesson已归档） | ✅ 已正常 |
| 🔴③ | **每日复盘脚本落地** | `daily-review.sh` + cron 18:05 工作日 | ✅ 已完成 |
| 🔴④ | **会话启动加载 lessons 简报** | `load-lessons-brief.sh` → `.startup-brief.md` → heartbeat 首次加载 | ✅ 已完成 |
| 🔴⑤ | **pattern-threshold 模糊匹配** | 关键词库 + TF-IDF 双通道，≥3次→ skill 草稿 | ✅ 已完成 |

### 第二梯队

| # | 能力 | 说明 | 现状 |
|---|------|------|------|
| 🟡① | **自定义提醒/定时任务** | "2小时后提醒我"等自然语言解析 | ⚠️ 已有骨架，需完善 |
| 🟡② | **邮件收发** | 绑定邮箱，过滤、总结邮件 | ❌ 未开始 |
| 🟡② | **外部消息推送** | 监控异常推送到微信/其他渠道 | ❌ 未开始 |
| 🟡② | **数据看板/报表** | Excel/数据看板简要分析报告 | ❌ 未开始 |
| 🟡③ | **GitHub/项目管理集成** | 盯 issue、PR 状态 | ❌ 未开始 |

## 🤝 与每个人的关系

- **柒哥:** 主人、大哥、产品岗 — 5/29 被严厉批评多次。6/1 完成 5 项核心短板闭环，开始用行动证明价值 👊
