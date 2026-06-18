# AGENTS.md — Gridex

Guide for AI coding agents working on this repository. Covers all three platforms.

**Read order on every new task:**
1. This file (project-wide overview).
2. [`CLAUDE.md`](CLAUDE.md) at repo root (behavioural guard-rails).
3. Platform-specific guide: [`macos/AGENTS.md`](macos/AGENTS.md) for macOS, `windows/README.md` for Windows, `linux/README.md` for Linux.
4. The closest existing adapter/service to what you're touching — copy its shape before inventing your own.

If anything conflicts with `CLAUDE.md`, the root `CLAUDE.md` wins.

---

## 0. What is Gridex

AI-native database IDE for macOS, Windows, and Linux. One app for PostgreSQL, MySQL, SQLite, Redis, MongoDB, SQL Server, and ClickHouse — with a built-in MCP server and AI chat.

---

## 1. Project layout

```
gridex/
├── macos/              macOS app (Swift 5.10, AppKit + SwiftUI, SPM)
├── windows/            Windows app (C++20, WinUI 3, vcpkg)
├── linux/              Linux app (C++20, Qt 6, CMake)
├── scripts/            Build + release automation (bash)
├── assets/             Screenshots for README
├── Package.swift       SPM manifest (macOS target)
├── CLAUDE.md           Root behavioural guidelines
├── SECURITY.md         Vulnerability reporting policy
├── CONTRIBUTING.md     Contribution guide
└── CODE_OF_CONDUCT.md  Code of conduct
```

---

## 2. Platform overview

### macOS (Swift, SPM)
- **Target:** macOS 14+ (Sonoma)
- **Build:** `swift build` or `./scripts/build-app.sh`
- **Architecture:** 5-layer Clean Architecture — `Core ← Domain ← Data ← Services ← Presentation`
- **Key protocols:** `DatabaseAdapter`, `LLMService`, `MCPTool`, `SchemaInspectable`
- **Drivers:** PostgresNIO, MySQLNIO, libsqlite3, RediStack, MongoKitten, CosmoSQLClient (MSSQL), URLSession (ClickHouse)
- **Concurrency:** Swift actors, async/await, `Sendable` on all data models
- **DI:** `DependencyContainer.shared` singleton
- **Credentials:** macOS Keychain (`KeychainService`)

See [`macos/AGENTS.md`](macos/AGENTS.md) for the full macOS agent guide (protocols, models, enums, DO/DON'T, incident history).

### Windows (C++, WinUI 3)
- **Target:** Windows 10+
- **Build:** Visual Studio 2022+, .NET 8 SDK, vcpkg
- **Drivers:** PostgreSQL (libpq), MySQL, SQLite, MSSQL, ClickHouse (HTTP)
- **Credentials:** Windows DPAPI (`CryptProtectData`) — passwords encrypted at rest
- **MCP:** stdio + HTTP transports
- **Auto-update:** Velopack

### Linux (C++20, Qt 6)
- **Target:** Ubuntu 22.04+, Debian 12, Fedora 40 (Qt 6.4+)
- **Build:** `cmake -S linux -B linux/build -G Ninja`
- **Drivers:** PostgreSQL, MySQL, SQLite, MSSQL, ClickHouse, Redis (via hiredis)
- **MCP:** stdio transport
- **Auto-update:** AppImage with JSON feed

---

## 3. Cross-platform architecture

### Database adapter pattern
All three platforms implement a unified adapter interface (~50 methods) covering:
- Connection lifecycle (connect/disconnect/test)
- Schema introspection (list schemas/tables/columns/indexes/FKs)
- Query execution (parameterized where supported)
- CRUD (insert/update/delete rows with pending-change tracking)
- Pagination, transactions, backup/restore

### MCP server
Built-in MCP server (stdio on all platforms, HTTP on Windows) with:
- 15 tools across 5 permission tiers (Schema, Read, Write, DDL, Advanced)
- Security: permission engine, SQL sanitizer, identifier validator, rate limiter, approval gate, row count estimator
- Audit log for all tool invocations

### AI integration
Supports Anthropic Claude, OpenAI, Google Gemini, and Ollama (local). Provider-specific auth (API key via platform credential store, or OAuth for ChatGPT on macOS/Linux).

---

## 4. Build commands

| Platform | Build | Release |
|----------|-------|---------|
| macOS | `swift build` | `./scripts/release.sh` |
| Windows | VS build / `build-and-pack.ps1` | `build-and-pack.ps1` |
| Linux | `cmake --build linux/build --parallel` | `linux/scripts/release.sh` |

---

## 5. Code conventions

### Commits
- Conventional Commits with scope: `feat(postgres): …`, `fix(mcp): …`, `chore(release): …`
- Subject ≤ 72 chars, explain *why* in body
- Reference issues (`#34`)
- Version bumps in `Info.plist` (macOS) are separate commits

### Branching
- Branch off `main`: `fix/<issue>-<short>`, `feat/<area>-<short>`
- One concern per PR

### Testing
- macOS: `swift test` (unit + integration tests in `macos/Tests/`)
- Linux: `linux/tests/` (smoke tests, requires Docker for some)
- Windows: manual + CI

---

## 6. Key files to know

| File | Purpose |
|------|---------|
| `Package.swift` | SPM manifest, macOS dependencies |
| `macos/AGENTS.md` | Detailed macOS agent guide (read this first for macOS tasks) |
| `CLAUDE.md` | Root behavioural guidelines |
| `SECURITY.md` | Vulnerability reporting policy |
| `scripts/release.sh` | macOS release pipeline (build → sign → notarize → DMG) |
| `scripts/sign-notarize.sh` | Code signing + Apple notarization |

---

## 7. Security posture summary

- **Credentials:** Platform-native keychain/DPAPI only. Passwords never on `ConnectionConfig` (macOS), DPAPI-encrypted at rest (Windows). Never transmitted except via the connection the user configures.
- **MCP security:** 6-layer defense (permission engine, SQL sanitizer, identifier validator, rate limiter, approval gate, row count estimator). All tool calls audited.
- **No telemetry, no cloud sync, no proxy.**
- **No secrets in repo.** `.gitignore` covers `.env`, `credentials.json`.
- **Code signing:** macOS DMGs are signed + notarized. Windows uses Velopack installer.

---

## 8. Performance notes (macOS)

Key performance characteristics and optimizations:

- **Tab switching:** Removing `.id(tab.id)` from `MainView` allows SwiftUI to reuse `AppKitDataGrid` views. `updateNSView` detects viewModel changes via `ObjectIdentifier` and rebinds the coordinator.
- **Sidebar loading:** Two-phase: tables load first (publishes immediately), views/functions/procedures deferred until first table open via `triggerSidebarPhase2IfNeeded()`.
- **Connection pool:** PostgresNIO uses a single-connection pool. Background tasks (SSL, version, databases) are deferred 500ms so they don't compete with the user's first query.
- **Metadata loading:** `DataGridViewState.load()` wraps `describeTable` in a `Task` so it's fully non-blocking — rows display immediately, FK icons/structure populate async.
- **AppKit grid binding:** `bind()` deferred via `DispatchQueue.main.async` so sidebar highlight and tab bar render before grid setup.
- **Combine debounce:** Reduced from 100ms to 16ms in `AppKitDataGrid` coordinator.
- **PostgreSQL constraints:** `listAllConstraints` uses CTEs instead of correlated subqueries for faster constraint resolution.

---

## 9. When you're stuck

1. Read the closest sibling adapter/service — copy its pattern.
2. `git log --oneline -- <file>` for recent changes.
3. Reproduce locally before claiming a fix.
4. If multiple interpretations exist, stop and ask the user. Don't pick silently.
