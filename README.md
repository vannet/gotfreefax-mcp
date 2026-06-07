<p align="center">
  <a href="https://www.gotfreefax.com">
    <img src="wordmark.png" alt="GotFreeFax" height="80" />
  </a>
</p>

# GotFreeFax MCP Server

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![MCP](https://img.shields.io/badge/MCP-2024--11--05-blue)](https://modelcontextprotocol.io/)

> Send faxes to the US and Canada from Claude, ChatGPT, Codex, and other AI agents over the [Model Context Protocol](https://modelcontextprotocol.io/). **No account required to start.**

- **Endpoint:** `https://www.gotfreefax.com/mcp`
- **Full docs:** <https://www.gotfreefax.com/mcp-server>
- **Service homepage:** <https://www.gotfreefax.com>

---

## What it does

The GotFreeFax MCP Server exposes [GotFreeFax.com](https://www.gotfreefax.com)'s fax-sending capabilities as MCP tools. An AI agent can:

- **Send a free fax** to any US/Canada number (3-page limit, 2/day per email & IP, email-confirmation required)
- **Send a paid fax** (up to 300 pages, no confirmation step) once the user has a prepaid account
- **Purchase prepaid credits** without leaving the chat — the tool returns a PayPal payment link
- **Check fax status, list sent faxes, and view account balance**

The free tier means a brand-new user can complete a real workflow ("Claude, please fax this to my doctor") with no signup. Paid tiers unlock larger documents and remove the confirmation step.

## Quick start (Claude Desktop, free, no account)

Add this to your `claude_desktop_config.json` and restart Claude Desktop:

```json
{
  "mcpServers": {
    "gotfreefax": {
      "command": "npx",
      "args": ["mcp-remote", "https://www.gotfreefax.com/mcp"]
    }
  }
}
```

Then ask Claude something like:

> *"Send a free fax to 555-123-4567 with the text 'Hello from Claude'."*

Claude calls `send_free_fax`, you receive a confirmation link by email, and the fax sends once you click it.

Requires Node.js installed locally — `mcp-remote` bridges Claude Desktop to the remote MCP endpoint.

## Available tools

| Tool | Description | Auth |
|---|---|---|
| `send_free_fax` | Send a free fax (≤3 pages, 2/day/email/IP, email-confirmation required) | None |
| `send_fax` | Send a fax via a prepaid account (≤300 pages, no confirmation) | Bearer |
| `check_fax_status` | Look up the delivery status of a fax by `job_id` | None |
| `list_sent_faxes` | List paid faxes the authenticated account has sent | Bearer |
| `get_account_balance` | Current page balance + dollar balance for the authenticated account | Bearer |
| `purchase_credits` | Start a prepaid credit purchase. Returns a PayPal payment URL. Authenticated → credits added to existing account; unauthenticated → creates account from email+name | Optional Bearer |
| `list_supported_formats` | Static list of accepted file types (PDF, DOC, DOCX, JPG, JPEG, TXT) | None |

See the [full documentation](https://www.gotfreefax.com/mcp-server) for per-tool parameter schemas and response shapes.

## Client setup

### Claude Desktop

**No credentials (free tools only):** see [Quick start](#quick-start-claude-desktop-free-no-account) above, or [examples/claude_desktop_config.json](examples/claude_desktop_config.json).

**With credentials (full access):** see [examples/claude_desktop_config.with-auth.json](examples/claude_desktop_config.with-auth.json).

### Codex CLI (OpenAI)

Add to `~/.codex/config.toml` — see [examples/codex.config.toml](examples/codex.config.toml).

### ChatGPT

ChatGPT's MCP support is rolling out across surfaces. The most reliable path as of mid-2026 is the ChatGPT desktop app's connector / MCP settings; the web UI uses an OAuth-based Connectors mechanism configured in account settings (not via JSON files). The values you need:

- **Endpoint:** `https://www.gotfreefax.com/mcp`
- **Transport:** Streamable HTTP (JSON-RPC 2.0 over POST)
- **Authentication (for paid tools):** Bearer token, format `"Bearer " + base64(account_number + ":" + pin)`

Follow OpenAI's current documentation for the exact UI steps.

### Cursor, Windsurf, and other MCP clients

Any client that speaks MCP over HTTP can connect. Use the same JSON shape as Claude Desktop in the client's MCP settings.

### Raw JSON-RPC (custom clients)

```bash
curl -X POST https://www.gotfreefax.com/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}'
```

See the [Examples section](https://www.gotfreefax.com/mcp-server#examples) of the canonical docs for full per-tool requests and responses.

## Authentication

Free tools work anonymously. Authenticated tools require an `Authorization` header:

```
Authorization: Bearer <base64(account_number:pin)>
```

Where `account_number` and `pin` come from a GotFreeFax prepaid account. You can buy one through the `purchase_credits` tool without leaving your AI client — after PayPal payment, account credentials are emailed to you.

Rate limiting: 5 failed auth attempts per IP per 30 min; 10 per account per 30 min. Detailed PIN/auth design at the [Authentication section](https://www.gotfreefax.com/mcp-server#authentication) of the docs.

## Pricing

| Tier | Cost | Includes |
|---|---|---|
| Free (`send_free_fax`) | $0 | 3 pages max, 2/day per email/IP, email-confirmation step |
| Prepaid 100 pages | $9.95 | `send_fax` with no confirmation step |
| Prepaid 250 pages | $19.95 | as above |
| Prepaid 800 pages | $49.95 | as above |
| International prepaid | $49.95 / $99.95 / $199.95 | dollar-balance-based, see docs |

`purchase_credits` returns a standard PayPal payment URL; payment is processed by PayPal. GotFreeFax does not store payment instruments.

## Privacy & terms

This MCP server is a thin protocol surface over the existing [GotFreeFax.com](https://www.gotfreefax.com) service. Standard service terms apply:

- **Terms of Service:** <https://www.gotfreefax.com/terms.aspx>
- **Privacy Policy:** <https://www.gotfreefax.com/privacy.aspx>

Fax content, sender/recipient identifiers, and account credentials are transmitted to GotFreeFax for delivery. No fax content is logged beyond what's required for delivery and statutory record-keeping.

## About this repo

This repository is the canonical project page for the GotFreeFax MCP Server, containing setup examples, an MCP manifest, and pointers to the live service. The server itself is hosted at `https://www.gotfreefax.com/mcp` — there is no local installation. The repo is published under the MIT License so the config snippets are free to copy into your own setups.

The server implementation is part of the GotFreeFax.com web application (closed-source).

## Links

- **MCP endpoint:** <https://www.gotfreefax.com/mcp>
- **Full developer documentation:** <https://www.gotfreefax.com/mcp-server>
- **REST API documentation:** <https://www.gotfreefax.com/fax-api>
- **GotFreeFax homepage:** <https://www.gotfreefax.com>
- **Model Context Protocol:** <https://modelcontextprotocol.io/>
- **`mcp-remote` (the npm bridge):** <https://www.npmjs.com/package/mcp-remote>
