# unustasis-data

Self-hosted garage data for the [unustasis app](https://github.com/reunu/unustasis) with upstream tracking and override support.

## Overview

This repository hosts service partner garage data with the following features:

- **Upstream tracking**: Original data from unumotors.com is fetched and stored in `garages_upstream.json`
- **Custom overrides**: Our modifications are stored separately in `garages_overrides.json`
- **Automated merging**: CI automatically applies overrides and publishes the merged result
- **GitHub Pages hosting**: The final `garages.json` is served at https://reunu.github.io/unustasis-data/garages.json

## Files

- `garages_upstream.json` - Original garage data from unumotors.com (~140 garages)
- `garages_overrides.json` - Our custom modifications (currently: updated Wilhelm details)
- `garages.json` - Generated merged file (published via GitHub Pages)

## CI Automation

The GitHub Actions workflow (`.github/workflows/update-garages.yml`):
- Runs daily at 3 AM UTC
- Fetches latest data from unumotors.com
- Detects changes in upstream data
- Applies our overrides using jq
- Commits and pushes updates if changes detected
- Can be triggered manually via workflow_dispatch

## Override Format

Overrides support three operations: **update**, **remove**, and **add**.

All operations use a `match` object to identify garages. You can match on any field(s) - commonly `name`, but you can also match on multiple fields for precision (e.g., `name` + `ShippingCity` if names aren't unique).

### Update Existing Garage

Modify information for an existing garage from upstream:

```json
{
  "operation": "update",
  "match": {
    "name": "Fa. Wilhelm Fahrzeugtechnik"
  },
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

**Multi-field matching example** (when name alone isn't unique):

```json
{
  "operation": "update",
  "match": {
    "name": "Scooter Shop",
    "ShippingCity": "Berlin"
  },
  "garage": { /* updated data */ }
}
```

### Remove Garage

Remove a garage that has closed or no longer services unu scooters:

```json
{
  "operation": "remove",
  "match": {
    "name": "Closed Garage Name"
  }
}
```

### Add New Garage

Add a garage not present in upstream data:

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

## Adding Overrides

1. For **updates** and **removes**: Identify the garage in `garages_upstream.json` and create a `match` object with field(s) to match on
2. For **adds**: Provide complete garage record in the `garage` field
3. Add the entry to `garages_overrides.json`
4. Run the workflow manually or wait for the next scheduled run
5. The merged `garages.json` will be automatically updated

## Reporting Outdated Information

If you notice incorrect garage information, please [open an issue](https://github.com/reunu/unustasis-data/issues/new/choose) using the "Outdated Garage Information" template

## License

Data sourced from unumotors.com with custom modifications by reunu.
