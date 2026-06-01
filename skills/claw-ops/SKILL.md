# Claw 运维技能

通过 paramiko SSH 连接云服务器，运维钉钉 Claw。

## 连接信息

| 属性 | 值 |
|:---|:---|
| 服务器 | 124.223.110.120 |
| 用户 | ubuntu |
| 密码 | 存储在 `secrets/weread.sh` 同目录 |
| SSH 方式 | paramiko (Python) |

连接模板：

```python
import paramiko
HOST = '124.223.110.120'
USER = 'ubuntu'
PASS = 'k+,_jeV`842dB'
client = paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
client.connect(hostname=HOST, username=USER, password=PASS, timeout=10)

def run(cmd):
    stdin, stdout, stderr = client.exec_command(cmd)
    return stdout.read().decode('utf-8', errors='replace').strip()
```

## 关键路径

| 用途 | 路径 |
|:---|:---|
| 主配置 | `/home/ubuntu/.openclaw/openclaw.json` |
| Sessions | `/home/ubuntu/.openclaw/agents/main/sessions/sessions.json` |
| Lessons | `/home/ubuntu/.openclaw/workspace/.lessons/` |
| Scripts | `/home/ubuntu/.openclaw/workspace/scripts/` |
| MEMORY.md | `/home/ubuntu/.openclaw/workspace/MEMORY.md` |
| behavior-log | `/home/ubuntu/.openclaw/workspace/.behavior-log.md` |
| 同步仓库 | `/home/ubuntu/workbuddy-sync/` |
| 告警 | `~/.connector_alerts.md`, `~/.session_alerts.md` |

## 常用操作

### 查看 Claw 状态

```python
status = run('sudo -u ubuntu openclaw status 2>/dev/null')
print(status)
```

关键指标：Channels 中的 DingTalk 状态、Sessions 数量、token 使用百分比

### 检查 API 连通性

```python
run('curl -s -m 10 https://api.deepseek.com/v1/models -H "Authorization: Bearer sk-XXXX" | head -c 50')
run('bash /home/ubuntu/.openclaw/workspace/scripts/check-deepseek-balance.sh')
```

### 检查进程状态

```python
run('ps aux | grep openclaw | grep -v chrome | grep -v grep')
run('free -h | head -2')
run('uptime')
```

### 清理溢出 session

```python
# 备份→清空→systemd 自动重启
run('cp ...sessions.json ...sessions.json.bak')
run('echo "{}" > ...sessions.json')
run('sudo systemctl restart openclaw-gateway')
```

### 部署新脚本

```python
sftp = client.open_sftp()
sftp.put('local/path/script.sh', '/home/ubuntu/.openclaw/workspace/scripts/script.sh')
sftp.close()
run('chmod 755 /home/ubuntu/.openclaw/workspace/scripts/script.sh')
```

### 管理 crontab

```python
# 查看
run('crontab -l')

# 添加（先去重，再追加）
run('crontab -l 2>/dev/null | grep -v "script-name" > /tmp/cron_new')
client.exec_command('echo "0 4 * * * /path/script.sh" >> /tmp/cron_new')
client.exec_command('crontab /tmp/cron_new')
```

### 推送知识到 Claw

```bash
python push-to-claw.py
```

文件命名规则决定去向：
- `lesson-*.md` → `.lessons/`
- `memory-*.md` → 覆盖 MEMORY.md
- `skill-*.md` → 覆盖 SKILLS.md
- `script-*.sh` → workspace 根目录
- `rule-*.md` → `.inbox-rules/`

## 常见故障处理

| 症状 | 原因 | 解决 |
|:---|:---|:---|
| 钉钉"处理中"卡住 | session token 满 (>90%) | 清 sessions.json，重启 |
| cron 不跑 | crontab 条目丢失 | 检查 `crontab -l`，补回 |
| 多实例冲突 | systemd 多重部署 | `ps aux` 找多余进程，`systemctl disable` |
| 重复 lesson | lesson-detector 去重失效 | 检查 dedup glob 是否用了 `*{scene}*.md` |
| Gateway 启动失败 | 端口被占或版本冲突 | `ss -tlnp` 查端口，关掉旧进程 |
| 内存高 (>80%) | Chrome/browser 泄漏 | `memory-watchdog.sh` 自动处理 |

## 同步机制

- Claw→GitHub：每 15min cron `sync-knowledge.sh`
- WorkBuddy→Claw：`push-to-claw.py` → incoming/ → cron 导入
- 共享仓库：`vmisty77/workbuddy-sync` (shared-knowledge/)

## 当前状态速查（2026-06-01）

- Claw v2026.5.18，单进程，ubuntu 用户
- systemd: `openclaw-gateway.service` (user)
- 43 scripts, 15 lessons
- 监控：session-token (每2h), connector-health (每15min), memory-watchdog (每30min), browser-restart (每周日)
- 已知缺口：微信渠道 (OpenClaw #68451), session 自动压缩, API 降级
