# Reference Manual

## Plugin Files
- `ExportDialogSections.lua`: Handles the export dialog UI and options.
- `Info.lua`: Plugin metadata and configuration.
- `ServiceProvider.lua`: Main logic for exporting and importing photos.

## Export Options
- JPEG quality: Always exports as high-quality JPEG (quality 100, sRGB).
- Metadata: Optionally strip person/location metadata.

## Apple Photos Integration
- Uses AppleScript to control Apple Photos.
- Creates or uses albums based on Lightroom folder names.

## Permissions
- Requires accessibility and automation permissions on macOS.
