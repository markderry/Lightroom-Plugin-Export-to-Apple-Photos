return {
    LrPluginName = "Apple Photos Publisher",
    LrToolkitIdentifier = "com.example.lightroom.applephotos",
    LrPluginInfoUrl = "https://github.com/markderry/lightroom_publish_to_apple_photos",
    LrSdkVersion = 10.0,
    LrSdkMinimumVersion = 6.0,
    LrInitPlugin = 'ServiceProvider.lua',
    LrExportServiceProvider = {
        title = "Apple Photos",
        file = 'ServiceProvider.lua',
        exportPresetFields = {
            { key = 'LR_export_bitDepth', default = 8 },
            { key = 'LR_export_colorSpace', default = 'sRGB' },
            { key = 'LR_export_useSubfolder', default = false },
            { key = 'LR_format', default = 'JPEG' },
            { key = 'LR_jpeg_quality', default = 1.0 },
            { key = 'LR_size_doConstrain', default = false },
            { key = 'LR_outputSharpeningOn', default = false },
            { key = 'includeMetadata', default = true },
            { key = 'removePersonInfo', default = true },
            { key = 'removeLocationInfo', default = true },
        },
        exportDialogSections = {
            { title = 'Apple Photos Settings', file = 'ExportDialogSections.lua' },
        },
    },
    VERSION = { major=0, minor=1, revision=0, build=1, },
}