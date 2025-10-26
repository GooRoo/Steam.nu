# Steam.nu

This module allows to get the information about games or apps from [Steam](https://store.steampowered.com/).

## Installation

```nushell
> nupm install --git git@github.com:GooRoo/Steam.nu.git
> use steam
```

## Usage

> [!WARNING]
> Steam applies some limits on the amount of requests. For me, roughly 2 requests per second worked fine.

### Detailed information

Get the detailed information:

```nushell
> 'https://store.steampowered.com/app/1328670/Mass_Effect_Legendary_Edition/' | steam app-details
╭───┬─────────┬─────────┬──────┬────────────────────────────────┬─────────────┬──────────────┬─────────┬─────────┬─────╮
│ # │   id    │ success │ type │              name              │ steam_appid │ required_age │ is_free │ control │ ... │
│   │         │         │      │                                │             │              │         │ ler_sup │     │
│   │         │         │      │                                │             │              │         │ port    │     │
├───┼─────────┼─────────┼──────┼────────────────────────────────┼─────────────┼──────────────┼─────────┼─────────┼─────┤
│ 0 │ 1328670 │ true    │ game │ Mass Effect™ Legendary Edition │     1328670 │ 16+          │ false   │ full    │ ... │
╰───┴─────────┴─────────┴──────┴────────────────────────────────┴─────────────┴──────────────┴─────────┴─────────┴─────╯
```

Specify the language of the response:

```nushell
> 1328670 | steam app-details --lang ukrainian
```

### Price overview

Get the prices information for one game:

```nushell
> 'https://store.steampowered.com/app/1328670/Mass_Effect_Legendary_Edition/' | steam price-overview
```

Get the prices for several games:

```nushell
> [1328670 1091500] | steam price-overview
╭───┬─────────┬─────────┬──────────┬─────────┬───────┬──────────────────┬───────────────────┬─────────────────╮
│ # │   id    │ success │ currency │ initial │ final │ discount_percent │ initial_formatted │ final_formatted │
├───┼─────────┼─────────┼──────────┼─────────┼───────┼──────────────────┼───────────────────┼─────────────────┤
│ 0 │ 1328670 │ true    │ EUR      │    5999 │   479 │               92 │ 59,99€            │ 4,79€           │
│ 1 │ 1091500 │ true    │ EUR      │    5999 │  5999 │                0 │                   │ 59,99€          │
╰───┴─────────┴─────────┴──────────┴─────────┴───────┴──────────────────┴───────────────────┴─────────────────╯
```

> [!TIP]
> You can mix numerical IDs with URLs. In the latter case, the URLs get parsed to extract the IDs.
