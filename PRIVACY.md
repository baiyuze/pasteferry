# Privacy

Also on the website in five languages: <https://pasteferry.cc/en/privacy/>.

## In short

What you copy, the files you send, their names and your notes travel
end-to-end encrypted between your own devices. We can't see them and don't
store them.

## Service (when turned on)

New installs use the local network only. When you turn on Service, your
devices connect to the official server so they can find each other across
networks. We keep a pseudonymous device number, first and last connection
times and daily relay usage. Only when a direct connection fails and relay is
needed does the app derive a PasteFerry-specific machine digest, so that one
computer shares one relay allowance. Real device names, raw system identifiers
and content are never uploaded. The fields are listed in the
[gateway protocol](design/official-gateway.md).

## Update checks

The app checks for updates once a day, fetching a signed update list from the
PasteFerry website, GitHub and Gitee. The request to the website includes the
version, system and language, and whether it is the first check of the day,
week or month, to provide the right update and plan future releases. No device
ID or account is included and IP addresses are not stored. Automatic checks
can be turned off in Settings → About. Updates install only after you confirm,
and only if they match a list signed with the PasteFerry release key.

## Contacts

A contact sees the display name and avatar you set, the name and system of the
computer you send from, and whether you use the local network, Service or your
own server (for your own server, only a digest of its address). Your clipboard,
history and other devices are never shared with contacts, and their files
arrive only after you accept them.

## Website

The website uses Cloudflare Web Analytics and keeps its own totals of page
views and download clicks (date, page path, page language, version and file
downloaded). No analytics cookies or persistent visitor identifiers are used,
and IP addresses and browser identifiers are not stored. With Do Not Track or
Global Privacy Control turned on, the website's own counters are not sent.

## How it is used

This information is used to provide and improve the service, publish updates,
keep the service secure and prevent abuse, measure and plan, and meet legal
obligations. We don't sell it or use it for advertising.

## Third parties

GitHub, Gitee, Cloudflare and any server you choose handle your requests to
them under their own privacy policies.

## Retention

Daily per-device detail for Service is kept for 90 days; daily totals without
personal identity are kept indefinitely.

## Your choices

You can use the local network only, turn off Service, turn off automatic update
checks, or run your own server. The PasteFerry client and server are open
source; see [SECURITY.md](SECURITY.md) for the trust model.

## Disclaimer and changes

PasteFerry and Service are provided free and as is; relay allowances and
features may change or be suspended. We are not liable for data loss or failed
syncs caused by networks, devices, third-party services or self-hosted servers.
Changes to this notice take effect when published on the website; continuing
to use PasteFerry means you accept them.

## Contact

Questions about this notice: open an issue at
<https://github.com/baiyuze/pasteferry/issues>.
