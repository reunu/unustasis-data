# unustasis-data

Self-hosted service partner garage data for [unustasis](https://github.com/reunu/unustasis).

Tracks upstream data from unumotors.com, applies our overrides, and publishes the result via GitHub Pages at:

```
https://reunu.github.io/unustasis-data/garages.json
```

## How It Works

| File | Purpose |
|------|---------|
| `garages_upstream.json` | Original data from unumotors.com (~179 garages) |
| `garages_overrides.json` | Our modifications (updates, removals, additions) |
| `merge-overrides.jq` | Merge script: applies overrides to upstream |
| `garages.json` | Generated output, published via GitHub Pages |

A weekly CI workflow fetches the latest upstream data, applies overrides, and commits if anything changed. Can also be triggered manually via workflow_dispatch.

## Override Format

Three operations, all using a `match` object to identify garages by any field(s):

### Update

```json
{
  "operation": "update",
  "match": { "name": "Fa. Wilhelm Fahrzeugtechnik" },
  "garage": {
    "name": "Fa. Wilhelm Zweiradtechnik",
    "Phone": "+49 175 222 99 77",
    "ShippingStreet": "General-Pape-Straße 8",
    "ShippingCity": "Berlin",
    "ShippingPostalCode": "12101",
    "ShippingCountry": "Germany",
    "ShippingCountryCode": "DE",
    "ShippingLatitude": "52.47627980463747",
    "ShippingLongitude": "13.367350417613736",
    "status": ""
  }
}
```

Match on multiple fields when names aren't unique:

```json
{ "match": { "name": "Scooter Shop", "ShippingCity": "Berlin" } }
```

### Remove

```json
{
  "operation": "remove",
  "match": { "name": "Closed Garage Name" }
}
```

### Add

```json
{
  "operation": "add",
  "garage": {
    "name": "New Garage Name",
    "Phone": "+49 30 12345678",
    "ShippingStreet": "Example Street 123",
    "ShippingCity": "Berlin",
    "ShippingPostalCode": "10115",
    "ShippingCountry": "Germany",
    "ShippingCountryCode": "DE",
    "ShippingLatitude": "52.5200",
    "ShippingLongitude": "13.4050",
    "status": ""
  }
}
```

## Reporting Outdated Information

Notice incorrect garage details? [Open an issue](https://github.com/reunu/unustasis-data/issues/new/choose) using the "Outdated Garage Information" template.
