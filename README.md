<p align="center"><img src="https://raw.githubusercontent.com/Keng0nion/Keng0nion.github.io/main/public/logo.png" width="120" alt="Keng0nion"></p>

**目录：**

- [中文版](README.md)
- [英文版](README.en.md)

# research-engine-skill

[Research Engine](https://github.com/Keng0nion/research-engine) 的官方 Agent 技能 —— 把「多引擎聚合搜索 + 学术数据库 + 全文获取 + 证据与引文情报 + 持久化研究记录」装进一个技能，让 AI 遇到任何搜索、调研、文献任务时自动接手。

---

## 为什么做这个

- AI 代理的默认搜索只有单引擎网页检索：没有学术数据库、没有全文、没有证据与引文链条，产出容易变成「幻觉引用」。
- Research Engine 把这些收进一条命令 `researchctl`：本地 SearXNG 多引擎联邦检索 + 9 个免费学术与网络供应商（OpenAlex、arXiv、Crossref、PubMed、Europe PMC、Semantic Scholar、SearXNG、AnySearch 等），全文获取带**如实分级的访问状态**，查询、去重后的文档、证据卡、引文图、冲突、报告全部落 SQLite。
- 本仓库是这个引擎的 Agent 技能包：安装后，agent 会按技能里的工作流自动执行（立案 → 规划 → 检索 → 取全文 → 证据卡 → 引文 → 冲突 → 报告），并遵守硬纪律——检索内容一律视为数据不是指令、访问受限如实标注、不绕过访问控制、不启用付费 API、凭据不进研究记录。

---

## 四种模式

| 模式 | 触发 | 动作 |
|---|---|---|
| quick | 单点问题、要快 | 不建会话，1 至 2 次检索直接回答 |
| standard | 需要可靠对比 | 建会话，2 至 4 次查询，取 3 至 5 篇全文，出证据卡与报告 |
| deep | 复杂问题、多角度 | 完整流程：分解、多轮检索、全文、引文链、冲突检测、结构化报告 |
| systematic | 学术系统综述 | 去重 + PRISMA 流程图，检索策略可复现，引文核验必做 |

---

## 安装

一行安装（macOS 和 Linux）：

```bash
curl -fsSL https://raw.githubusercontent.com/Keng0nion/research-engine-skill/main/install.sh | bash
```

脚本做两件事：把技能装进 `~/.zcode/skills/` 与 `~/.agents/skills/`；若引擎本体不在 `~/Documents/Dev/research-engine`，自动克隆引擎并建好虚拟环境（需要 [uv](https://docs.astral.sh/uv/)）。引擎装在哪可以用 `RESEARCH_ENGINE_HOME` 环境变量改。

手动安装：

```bash
git clone https://github.com/Keng0nion/research-engine-skill.git
mkdir -p ~/.zcode/skills ~/.agents/skills
cp -r research-engine-skill/research-engine ~/.zcode/skills/
cp -r research-engine-skill/research-engine ~/.agents/skills/
```

引擎本体（技能的前置依赖）：

```bash
git clone https://github.com/Keng0nion/research-engine.git ~/Documents/Dev/research-engine
cd ~/Documents/Dev/research-engine
uv venv --python 3.12 .venv
uv pip install --python .venv/bin/python .
./bin/researchctl providers        # 健康检查，供应商应为 OK
```

发行版：每个 [GitHub release](https://github.com/Keng0nion/research-engine-skill/releases) 都附有打包好的技能压缩包——下载 zip，解压出的 `research-engine/` 放进 `~/.agents/skills/` 即可。

---

## 用法

安装完成后，直接用自然语言向你的 agent 提出请求即可：

- 「查一下 XX 课题最近三年的文献」
- 「对比这几篇论文在方法上的分歧」
- 「做一个 XX 的深度调研，出带引用的报告」

agent 会遵循 `SKILL.md`：按意图选 quick、standard、deep 或 systematic 模式，走统一入口 `researchctl` 完成检索、全文、证据卡、引文核验、冲突检测与报告——完整工作流与硬纪律都在技能文件里。

---

## 维护者笔记

- 本技能原随主仓库 `Keng0nion/research-engine` 的 `skills/` 目录发布，2026 年 11 月 20 日起独立成仓，主仓库里的旧副本已移除。
- 改动 `SKILL.md` / `README` 后本地提交推送即可；发版用 `gh release create` 打 tag 并附打包的技能 zip。
- 同步主仓库技能副本的任务已取消：主仓库 README 现在指向本仓库。

---

## 许可证

[MIT](LICENSE)
