# NextDNS — systemd-resolved (no client daemon)

DNS protection via **systemd-resolved** with NextDNS over TLS. No `nextdns` CLI/service installed.

## Configuration

`/etc/systemd/resolved.conf`:

```ini
[Resolve]
DNS=45.90.28.0#2f49ca.dns.nextdns.io
DNS=2a07:a8c0::#2f49ca.dns.nextdns.io
DNS=45.90.30.0#2f49ca.dns.nextdns.io
DNS=2a07:a8c1::#2f49ca.dns.nextdns.io
DNSOverTLS=yes
```

- Config ID: `2f49ca`
- IPv4: `45.90.28.0` / `45.90.30.0`
- IPv6: `2a07:a8c0::` / `2a07:a8c1::`
- Fallback: Quad9 (`9.9.9.9`) via systemd's built-in fallback list

## How it works

1. NetworkManager writes the stub resolver (`nameserver 127.0.0.53`) to `/etc/resolv.conf` (generated).
2. systemd-resolved forwards everything to the NextDNS DoT upstreams from `resolved.conf`.
3. `DNSOverTLS=yes` = opportunistic — plaintext only if the server refuses TLS.

Verify:

```bash
resolvectl status                     # Current DNS Server: 45.90.28.0#2f49ca.dns.nextdns.io
resolvectl query example.com
```

## Change config ID

Edit `DNS=` lines in `/etc/systemd/resolved.conf`, then:

```bash
sudo systemctl restart systemd-resolved
```

## Notes

- NextDNS hostname (`#2f49ca.dns.nextdns.io`) is required for the TLS Server Name Indication (SNI) — without it DoT can't select the right NextDNS config.
- No per-connection DNS settings in NetworkManager — global `resolved.conf` covers all links.