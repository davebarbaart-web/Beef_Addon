The Interface number follows a `MMiiPP` format where periods and leading zeros are stripped from the version string. Classic branches retain their era-based numbering.

| Client | Era | Interface Number | Notes |
|---|---|---|---|
| Retail (The War Within / Midnight prepatch) | Modern | `120005` (12.0.5) and later | Cumulative numbering ([1_toc_interface_version_numbers_2024_2026[0]] [16]) |
| Classic Era / Classic Anniversary (20th Anniversary) | Vanilla (1.15.x) | `11508` (1.15.8) | Used through 2025 |
| Season of Discovery | Vanilla (1.15.x) | `11508` | Shares client with Classic Era |
| Burning Crusade Classic Anniversary | TBC (2.5.x) | `20504` (2.5.4) | Launched January 2026 ([1_toc_interface_version_numbers_2024_2026[1]] [42]) |
| Wrath Classic (and Anniversary branch) | WotLK (3.4.x) | `30405` (3.4.5) | |
| Cataclysm Classic | Cata (4.4.x) | `40402` (4.4.2) | Live through 2025 ([1_toc_interface_version_numbers_2024_2026[2]] [31]) |

**Key rules:**
- Every client patch that changes the API bumps Interface by one.
- `## Interface: 120005, 40402` declares compatibility with both retail and Cataclysm Classic.
- Suffixed TOCs (`_Vanilla`, `_Classic`, `_BCC`, `_Wrath`, `_Mainline`) load only on matching clients; `_Mainline` targets retail (>=11.0.0) and `_Classic` now applies to all Classic clients per Blizzard's 2024 update.

---