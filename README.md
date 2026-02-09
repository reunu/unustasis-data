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

Overrides are stored as an array of objects with `originalName` and `override` fields:

```json
[
  {
    "originalName": "Fa. Wilhelm Fahrzeugtechnik",
    "override": {
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
]
```

## Adding New Overrides

1. Find the garage's `name` field in `garages_upstream.json`
2. Add a new entry to `garages_overrides.json` with:
   - `originalName`: The exact name from upstream
   - `override`: Complete garage record with your modifications
3. Run the workflow manually or wait for the next scheduled run
4. The merged `garages.json` will be automatically updated

## License

Data sourced from unumotors.com with custom modifications by reunu.
