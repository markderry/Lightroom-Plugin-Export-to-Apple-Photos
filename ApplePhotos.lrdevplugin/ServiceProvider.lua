local LrTasks = import 'LrTasks'
local LrDialogs = import 'LrDialogs'

local exportServiceProvider = {}



function exportServiceProvider.processRenderedPhotos(functionContext, exportContext)
    LrTasks.startAsyncTask(function()
        local exportSession = exportContext.exportSession
        local nPhotos = exportSession:countRenditions()

        -- Try to get the folder name from the export context
        -- We'll use the original folder name for each photo as the album name


        -- Set a fixed export location (e.g., ~/Pictures/LightroomToApplePhotosTemp)
        local LrPathUtils = import 'LrPathUtils'
        local LrFileUtils = import 'LrFileUtils'
        local home = LrPathUtils.getStandardFilePath('home')
        local exportDir = home .. "/Pictures/LightroomToApplePhotosTemp"
        LrFileUtils.createAllDirectories(exportDir)

        for i, rendition in exportSession:renditions{ stopIfCanceled = true } do
            local success, pathOrMessage = rendition:waitForRender()
            if success then
                local photoPath = pathOrMessage
                -- Move the file to the fixed export location
                local fileName = photoPath:match("[^/]+$")
                local destPath = exportDir .. "/" .. fileName
                LrFileUtils.move(photoPath, destPath)

                -- Get the original folder name from the catalog
                local albumName = ""
                local photo = rendition.photo
                if photo then
                    local folderName = photo:getFormattedMetadata("folderName")
                    if folderName then
                        albumName = folderName
                    end
                end
                if albumName == "" then
                    albumName = "Lightroom Export"
                end


                -- Metadata stripping is now handled by Lightroom's built-in export options

                -- AppleScript to import photo into Apple Photos
                local script = [[
                    on run argv
                        set photoPath to POSIX file (item 1 of argv)
                        set albumName to item 2 of argv
                        tell application "Photos"
                            activate
                            if albumName is not "" then
                                if not (exists container named albumName) then
                                    make new album named albumName
                                end if
                                import photoPath into container named albumName with skip check duplicates
                            else
                                import photoPath with skip check duplicates
                            end if
                        end tell
                    end run
                ]]
                -- Write AppleScript to temp file
                local tempScriptPath = os.tmpname() .. ".applescript"
                local f = io.open(tempScriptPath, "w")
                f:write(script)
                f:close()
                -- Run AppleScript via osascript
                local command = string.format('osascript %s %q %q', tempScriptPath, destPath, albumName)
                local result = LrTasks.execute(command)
                LrFileUtils.delete(tempScriptPath)

                -- Delete the exported photo after import
                LrFileUtils.delete(destPath)
            else
                LrDialogs.message("Export failed", pathOrMessage, "critical")
            end
        end
        LrDialogs.message("Apple Photos Plugin", "Exported " .. nPhotos .. " photo(s) to Apple Photos.")
    end)
end

return exportServiceProvider
