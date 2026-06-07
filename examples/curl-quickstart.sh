#!/usr/bin/env bash
# Raw JSON-RPC examples against the GotFreeFax MCP endpoint.
# No auth needed for any of these (all four tools used here are public).

ENDPOINT="https://www.gotfreefax.com/mcp"

echo "==> tools/list"
curl -s -X POST "$ENDPOINT" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}' \
  | jq .

echo
echo "==> tools/call list_supported_formats"
curl -s -X POST "$ENDPOINT" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 2,
    "method": "tools/call",
    "params": {
      "name": "list_supported_formats",
      "arguments": {}
    }
  }' | jq .

echo
echo "==> tools/call send_free_fax (text-only, requires real fax_number + sender_email)"
echo "    Uncomment the block below and fill in values to actually send."
# curl -s -X POST "$ENDPOINT" \
#   -H "Content-Type: application/json" \
#   -d '{
#     "jsonrpc": "2.0",
#     "id": 3,
#     "method": "tools/call",
#     "params": {
#       "name": "send_free_fax",
#       "arguments": {
#         "fax_number": "5551234567",
#         "sender_name": "Alice",
#         "sender_email": "alice@example.com",
#         "receiver_name": "Bob",
#         "text": "Hello from a curl quickstart."
#       }
#     }
#   }' | jq .
