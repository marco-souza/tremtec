---
title: "Tools for a Polyglot Engineer"
description: "Eight tools that make jumping between languages seamless: tmux, neovim, Ghostty, mise, opencode, GPG, Cloudflare, and Pulumi."
date: 2026-04-14
author: "TremTec Team"
tags: ["Developer Experience", "Tooling", "Productivity"]
---

Every polyglot engineer pays a tax. It's not money—it's context.

Switching from a Python FastAPI project to a Rust CLI to a Node.js frontend isn't just syntax. It's package managers, linters, formatters, runtime versions, editor configs, and mental models. The overhead piles up until you're spending more time managing your tools than writing code.

These eight tools minimize that tax. They're terminal-first, cross-platform, and designed to fade into the background once you learn them.

## tmux

Your terminal deserves sessions that survive SSH disconnects and system reboots.

```bash
# macOS
brew install tmux

# Linux (Ubuntu/Debian)
sudo apt install tmux

# Linux (Fedora)
sudo dnf install tmux

# Linux (Arch)
sudo pacman -S tmux
```

tmux lets you detach and reattach sessions, split panes across projects, and share terminals with teammates. For polyglot work, this means keeping separate contexts for each language without mixing state.

```bash
# Quick start: split your terminal horizontally
Ctrl-b "     # horizontal split
Ctrl-b %     # vertical split
Ctrl-b d     # detach
tmux attach  # reattach
```

The key insight: your session state shouldn't depend on your laptop staying awake.

## neovim

Text editing across languages requires one editor that adapts to all of them.

```bash
# macOS
brew install neovim

# Linux (Ubuntu/Debian)
sudo apt install neovim

# Linux (Fedora)
sudo dnf install neovim

# Linux (Arch)
sudo pacman -S neovim
```

Neovim 0.10+ ships with core LSP support, tree-sitter syntax highlighting, and a defaults-first philosophy. You get intelligent autocomplete, go-to-definition, and find-references without configuring a dozen plugins.

```lua
-- ~/.config/nvim/init.lua (minimal setup)
-- Enable core LSP with your preferred language servers
require("lspconfig")

vim.lsp.config("*", {
  flags = { debounce_text_changes = 150 }
})

local servers = { "gopls", "rust_analyzer", "lua_ls", "ts_ls" }
for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end
```

The key insight: neovim today requires far less configuration than it did three years ago.

## Ghostty

Your terminal emulator is where you spend half your day. It should be fast.

```bash
# macOS
brew install ghostty

# Linux: Build from source (requires Zig, GTK4, libadwaita)
# See https://ghostty.org/docs/install/linux
```

Ghostty 1.3 runs on Metal (macOS) or OpenGL (Linux), rendering at 60fps even with ligatures. Features include scrollback search, native tabs and splits, and a cross-platform core written in Zig.

```ini
# ~/.config/ghostty/config
font-family = "JetBrains Mono"
font-size = 13
theme = "dark-matrix"
```

The key insight: GPU acceleration isn't overkill—it's noticeable when you're staring at this screen for hours.

## mise

Replacing nvm, pyenv, rbenv, goenv, and rustup with one tool.

```bash
# Install (works on macOS and Linux)
curl https://mise.run | sh

# Activate (add to your shell rc)
eval "$(mise activate zsh)"
# or
eval "$(mise activate bash)"
```

Mise manages 100+ tool versions from a single CLI. It reads existing `.nvmrc`, `.python-version`, and `.tool-versions` files, so migration is trivial.

```toml
# mise.toml
[tools]
node = "20"
python = "3.12"
go = "1.22"
rust = "latest"
```

```bash
# Per-project versions auto-swap on cd
cd ~/project-python  # mise activates python@3.12
cd ~/project-go     # mise activates go@1.22
```

The key insight: one tool for any language eliminates the cognitive overhead of version switching.

## opencode

An AI coding agent ([Opencode GO](https://opencode.ai/docs/go/) for friendly pricing) that integrates with your existing workflow.

```bash
# Install (works on macOS and Linux)
curl -fsSL https://opencode.ai/install | sh

# Configure with your model provider (use [Opencode GO](https://opencode.ai/docs/go/) for friendly pricing)
opencode /connect
```

OpenCode (from Anomaly) is a terminal-based AI coding agent with built-in project understanding. Run `/init` to analyze your codebase and generate an `AGENTS.md` file that teaches the agent your project structure.

```bash
opencode
/init
```

Then ask questions or delegate implementation:

```
How does authentication work in this codebase?
Add a rate limiting middleware to the user API.
```

The agent mode (tap `Tab`) switches to read-only analysis—you get plans without execution.

The key insight: AI coding agents work best when they understand your project's patterns. `/init` does that automatically.

## AI Compatibility

Modern AI coding agents like opencode are designed to work seamlessly with terminal-native tools. This isn't accidental—it's by design.

### How CLI Tools Enhance AI Agent Workflows

When opencode analyzes your project, it benefits from the same tools you use:

- **mise**: The agent detects your `.tool-versions` or `mise.toml` and automatically uses the correct language versions when running commands
- **tmux**: The agent can create and manage sessions within your existing tmux environment
- **neovim**: When suggesting code edits, the agent speaks the same language as your LSP configuration
- **Ghostty**: The agent's terminal UI renders correctly in this modern emulator
- **GPG**: The agent can handle encrypted files when you provide the necessary keys

### Skills That Multiply Your Effectiveness

These combinations create powerful workflows:

1. **mise + opencode**:

   ```
   # Agent understands your project's Node.js version
   opencode "Add TypeScript support to this project"
   # Uses node@20 from mise.toml automatically
   ```

2. **tmux + opencode**:

   ```
   # Split your tmux pane
   Ctrl-b %
   # Left: opencode working on implementation
   # Right: Your terminal running tests
   ```

3. **neovim + opencode**:

   ```
   # Agent suggests changes using your existing LSP setup
   # No configuration mismatch between you and the agent
   ```

4. **Cloudflare + Pulumi + opencode**:
   ```
   # Agent can help write Pulumi infrastructure
   # Then deploy it with wrangler
   opencode "Add a Cloudflare KV namespace for user sessions"
   ```

The key insight: AI agents aren't replacements for your toolchain—they're force multipliers that work best when your tools are modern, terminal-native, and well-configured.

## GPG

Encrypting sensitive files—SSH keys, credentials, client data—with mathematical certainty.

```bash
# macOS
brew install gnupg

# Linux (Ubuntu/Debian)
sudo apt install gnupg

# Linux (Fedora)
sudo dnf install gnupg

# Linux (Arch)
sudo pacman -S gnupg
```

```bash
# Generate a key (only once)
gpg --full-generate-key

# Encrypt a file
gpg -o file.tar.gz.gpg -c file.tar.gz

# Decrypt
gpg -o file.tar.gz -d file.tar.gz.gpg
```

For polyglot engineers managing multiple client projects, GPG provides encryption that survives any tool rebuild. No vendor lock-in.

```bash
# Encrypt with recipient (for teammates)
gpg -o secrets.yaml.gpg -r colleague@example.com secrets.yaml
```

The key insight: encryption that works everywhere is worth the upfront key setup.

## Cloudflare

Deploy your code to the edge with zero infrastructure management.

```bash
# macOS
brew install cloudflare/wrangler/wrangler

# Linux (via npm)
npm install -g wrangler

# Or via cargo
cargo install wrangler
```

Cloudflare Workers run in 300+ data centers worldwide. Your code executes closest to the user—not in `us-east-1`.

```bash
# Login
wrangler login

# Deploy
wrangler deploy
```

```json
// wrangler.jsonc
{
  "name": "my-app",
  "main": "./dist/_worker.js",
  "compatibility_date": "2026-04-01",
  "assets": {
    "directory": "./dist/client"
  }
}
```

The key insight: you don't need a server. You need compute at the edge.

## Pulumi

Infrastructure as actual code—not YAML templates.

```bash
# Install (macOS and Linux)
brew install pulumi

# Or via script
curl -fsSL https://get.pulumi.com | sh
```

Pulumi lets you write infrastructure in TypeScript, Python, Go, or .NET. The same language as your application.

```typescript
// infra/index.ts
import * as cf from "@pulumi/cloudflare";

const zone = new cf.Zone("example.com", {
  name: "example.com",
  plan: "free",
});

const record = new cf.Record("www", {
  zoneId: zone.id,
  name: "www",
  type: "CNAME",
  value: "my-app.workers.dev",
  proxied: true,
});
```

```bash
# Deploy
pulumi up
```

No learning a DSL. If you know Python, you write Python IaC. If you know Go, you write Go IaC.

```bash
# Stack management
pulumi stack init prod
pulumi stack init staging
pulumi up --stack prod
```

The key insight: infrastructure that uses the same language as your app is easier to maintain than a separate YAML dialect.

## The Reflection

**Quick to Start**: Every tool on this list installs in under 2 minutes. No Dockerfiles, no init systems.

**Cross-Platform**: macOS and Linux are first-class citizens. Your config travels—`~/.config/` syncs across machines via dotfiles.

**Terminal-First**: 100% keyboard-driven, works over SSH, zero rendering lag, no Electron bloat. Your hands never leave the keyboard.

**Flexibility**: Switch between Python API, Rust CLI, and JS frontend without thinking about versions. Mise handles the switch automatically.

**Continuous Learning**: None of these tools have a ceiling. You'll discover something new in neovim next year. That's the point—you're never done improving.

**Deploy & Infrastructure**: Cloudflare handles deployment, Pulumi handles infrastructure-as-code. Together they replace Chef, Terraform, and most DevOps tooling with far less complexity.

---

The best tools are the ones that disappear. You think about your code, not your setup.

[Opencode GO]: https://opencode.ai/docs/go/
