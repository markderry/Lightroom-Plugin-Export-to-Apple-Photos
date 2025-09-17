# Lightroom Classic to Apple Photos Export Plugin

This plugin allows you to export photos from Adobe Lightroom Classic directly into Apple Photos, automatically creating or using an album that matches the original folder name in your Lightroom catalog.

## Features
- Export photos from Lightroom Classic to Apple Photos on macOS
- Automatically creates and uses an Apple Photos album matching the Lightroom folder name
- Optionally strips person and location metadata before import
- Optionally exports as high-quality JPEG (quality 100, sRGB)
- Cleans up temporary files after import to Apple Photos

## Requirements
- macOS with Apple Photos installed
- Adobe Lightroom Classic

## Installation
1. Download or clone this repository.
2. Locate the `ApplePhotos.lrdevplugin` folder inside the project.
3. Open Lightroom Classic.
4. Go to `File > Plug-in Manager...`.
5. Click `Add` and select the `ApplePhotos.lrdevplugin` folder.
6. The plugin should now appear in the list. If there are errors, Lightroom will display them in the Plug-in Manager.

## Usage
1. In Lightroom Classic, select the photos you want to export.
2. Go to `File > Export...` and choose `Apple Photos` as the export destination.
3. Configure export options as desired:
   - Use Lightroom's built-in metadata options to control what metadata is included or stripped (including person and location info).
4. Click `Export`.
5. The plugin will:
   - Export each photo as a high-quality JPEG to a temporary folder
   - Import each photo into Apple Photos, creating or using an album matching the Lightroom folder name
   - Clean up temporary files

## Notes
- The plugin uses AppleScript to control Apple Photos. You may be prompted to grant permissions the first time you use it.
- If you export multiple photos from different folders, each will be imported into its corresponding album in Apple Photos.
- The plugin is designed for export only (not publish services).

## Troubleshooting
- If photos do not appear in Apple Photos, ensure you have granted automation permissions to Lightroom and the plugin in System Preferences > Security & Privacy > Privacy > Automation.
- If you encounter errors:
    - check the Plug-in Manager for details.
    - restart Lightroom and try again.
    - start an issue on GitHub if problems persist.


## License
MIT

## Author
Mark Derry

## Privacy Policy
See [privacy_policy.md](./privacy_policy.md) for details on how this plugin handles your data.