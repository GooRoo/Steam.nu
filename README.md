# Steam.nu

This module allows to get the information about games or apps from [Steam](https://store.steampowered.com/).

## Installation

```nushell
> nupm install --git git@github.com:GooRoo/Steam.nu.git
> use steam
```

## Usage

> [!WARNING] Limits
> Steam applies some limits on the amount of requests. For me, roughly 2 requests per second worked fine.

### Detailed information

Get the detailed information:

```nushell
> 'https://store.steampowered.com/app/1328670/Mass_Effect_Legendary_Edition/' | steam app-details
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
```

> [!TIP]
> You can mix numerical IDs with URLs. In the latter case, the URLs get parsed to extract the IDs.
