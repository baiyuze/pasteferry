# CLI queries and JSON output

PasteFerry 2.9 adds a version command and structured read-only queries to the
existing desktop CLI. These queries use the same authenticated local RPC
connection as the desktop app. The CLI controls an existing background service;
it does not install or start one.

## Commands

Global flags must precede the command. Both `-json` and `--json` are accepted.

```sh
pasteferry-cli version
pasteferry-cli -json version
pasteferry-cli -json status
pasteferry-cli -json devices
pasteferry-cli -json history
pasteferry-cli -json config
pasteferry-cli -json config get
pasteferry-cli -json -data-dir /path/to/running-instance status
```

`version` reports the CLI executable version without contacting a service.
`status` reports the service version, which can differ from the CLI version.
`config get` is an alias for `config`, including in text mode.

## Response format

Each JSON invocation writes one JSON object followed by a newline to stdout.
Success has exit code 0:

```json
{"ok":true,"data":{"version":"2.9.0"}}
```

Failures have a nonzero exit code and an error description:

```json
{"ok":false,"error":"daemon 未运行（找不到 /path/to/daemon.json）"}
```

Errors from supported queries, invalid arguments and unsupported JSON commands
use this envelope. Global flag parsing stops at the command, as with Go's
standard flag parser; put `-json` before other flags to request JSON errors for
invalid flags as well. JSON mode does not write diagnostic text to stderr.
Error descriptions are intended for people and should not be parsed as codes.

| Query | `data` contents |
| --- | --- |
| `version` | `version`: the CLI version string |
| `status` | `pid`, `port`, and `daemon`: the RPC Status message |
| `devices` | The RPC ListDevicesResponse, including `self` and `peers` |
| `history` | The RPC ListHistoryResponse, including `records` |
| `config [get]` | The RPC Config message |

RPC messages follow [ProtoJSON](https://protobuf.dev/programming-guides/json/):
field names use snake_case, booleans remain booleans, enums use their full names
(for example `CONNECTION_KIND_DIRECT`), and 64-bit integers use decimal strings
to preserve precision in JavaScript. Default scalar fields are included. Empty
repeated fields are `[]`, and absent optional messages are `null`.
Consumers should tolerate additional fields in future versions.

For example, no paired devices produces `data.peers: []`; no history produces
`data.records: []`. History returns up to 20 recent record summaries, matching
the existing text command, and does not fetch file content or alter the
clipboard. The endpoint authentication token is never included in the output.

The data fields are defined in
[`proto/pasteferry/v1/daemon.proto`](../proto/pasteferry/v1/daemon.proto).
Each RPC request has a five-second deadline, including configuration queries.

## Compatibility and scope

Without `-json`, existing commands keep their human-readable output and behavior.
JSON mode supports only the queries listed above. Commands that pair devices,
change settings, write the clipboard or modify history are rejected before any
RPC call. Existing text-mode operation commands remain available.

The new CLI can query an existing 2.8.3 service. There are no device protocol or
server changes in this feature.
