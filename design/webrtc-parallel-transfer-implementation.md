# Adaptive independent WebRTC file connections

Implementation and verification: 2026-11-13. Baseline: PasteFerry 2.11.2,
commit `2ebc01962397c39be79c05027266f5fd6aa4dcd0`.

## Behavior

- Both peers must explicitly advertise `send_files_parallel_v1`. Unknown or
  missing capability uses the original `send:<id>:<attempt>` channel and original
  file protocol. This applies in both sending directions.
- LAN TLS/TCP remains preferred. Relayed transfers retain the original channel.
- A negotiated direct transfer starts on the existing PeerConnection, using
  `send:<id>:<attempt>:striped`. After ten seconds below 256 KiB/s, with more than
  thirty seconds of estimated work remaining, it can try another independent
  WebRTC connection. Pending bytes count toward remaining work even when all
  source bytes have already entered the compressor.
- Connections grow from one to two, then up to four if two consecutive
  five-second observation windows show at least 20% aggregate goodput improvement.
  These are initial policy values, not measured universal optimal settings.
- Unhelpful connections are closed and their unacknowledged blocks are retried
  on surviving connections. Failed probes have a thirty-second cooldown.
  An auxiliary connection with outstanding data and no acknowledgements for
  thirty seconds is also removed.
- The existing control connection plus at most three independent connections
  share a per-device budget, including simultaneous transfers in both directions.
  A failed extra handshake continues the existing transfer. Extra connections
  use STUN/host candidates only and cannot silently fall back to TURN.

## Protocol and compatibility

The first implementation stripes the existing compressed file byte stream,
rather than replacing its file framing with a new sparse file-range protocol.
This retains existing metadata handling, source-change checks, destination path
rules, final file SHA-256 verification, and file checkpoints.

Each transport block has a sequence number, payload length and SHA-256 checksum.
Payloads are at most 64 KiB. The receiver validates and reorders blocks before
exposing bytes to the existing decompressor. Its ordered reader acknowledges
accepted blocks, limiting the sender and receiver's transport window to 32
blocks (2 MiB of payload; Pion and codec buffers are additional).

Each lane initially owns at most one unacknowledged block. Its application
window grows when delivery is fast, up to the shared limit. This keeps a slow
first lane from taking the entire work queue before extra connections arrive.

The stream end marker is explicitly acknowledged. On WebRTC the receiver drains
that final acknowledgement before reporting the file transfer as delivered.
Transport EOF is classified as a network interruption, not source-file EOF.

Independent connections negotiate SDP inside a separate data channel on the
already authenticated primary connection. Each has its own UDP socket, ICE,
DTLS and SCTP association. The primary socket's public candidate mappings are
never copied to the new socket. No signaling-server or protobuf change is needed.
Incoming negotiations must match an accepted transfer, device and attempt.

During a live attempt, failed-lane blocks are replayed and duplicates are
discarded. After a process restart or primary-stream interruption, the existing
file checkpoint is used: received but not yet decoded out-of-order bytes may be
sent again. Persistent sparse block maps, per-file-range compression, and dynamic
transport block sizing are not part of this implementation. A resumed transfer
can switch back to the legacy channel without losing its file checkpoint.

## Verification

The implementation was checked with:

```sh
cd client-core
go test ./...
go test -race ./internal/transport/striped ./internal/send ./internal/transport/p2p \
  -run 'TestParallel|TestIndependent|TestThreeIndependent|TestAdaptive|TestOrdered|TestRejects|TestCancellation|TestRefuses' -count=1
GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -o /tmp/pasteferry-parallel-windows.exe ./cmd/pasteferryd
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o /tmp/pasteferry-parallel-linux ./cmd/pasteferryd
```

Coverage includes:

| Case | Verification |
| --- | --- |
| New sender / legacy capability receiver | Original channel, payload equality |
| Legacy capability sender / new receiver | Original channel, payload equality |
| New sender / new receiver | Striped channel, payload equality |
| Independent WebRTC | Data continues after the original PeerConnection closes |
| Four-connection limit | Primary plus three real independent WebRTC sessions; fifth refused |
| Automatic scaling | Simulated independent lane bandwidth grows one to two to four |
| Unhelpful extra lane | Removed; cooldown prevents repeated probes |
| Extra lane fails mid-file | File succeeds in the same transfer attempt |
| Primary stream interruption | File resumes from a nonzero checkpoint |
| Resume after capability disappears | Resumes successfully using the legacy channel |
| Cancellation | Writer unblocks and partial files are removed |
| Invalid data | Corruption, oversized blocks and excessive reordering rejected |

### Actual archived-core interoperability

The reproducible check builds the archived 2.11.2 file engine and the working
tree engine into separate processes, then connects their real Pion transports:

```sh
python3 scripts/test-transfer-interop.py
```

The default baseline is the full commit above; `--legacy-ref` selects another
local legacy Git ref. The harness uses isolated temporary databases, download
directories and loopback HTTP signaling. It does not access installed apps or
the user's paired devices. The temporary artifact directory is printed and
contains logs and `results.json`.

Both directions passed with 4,194,323 bytes of file data per direction, including
Chinese/emoji paths, an empty file, an empty directory and a symbolic link.
Every regular file was checked with SHA-256, and neither side opened a striped
channel when paired with the archived legacy core.

These checks establish functional interoperability and failure recovery. They
do not establish a fixed speedup on a particular public network. The earlier
WAN experiments and their limitations are recorded in
[the feasibility report](webrtc-parallel-transfer-feasibility-2026-11-13.md).
