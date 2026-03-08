local LrTasks = import 'LrTasks'
local LrDialogs = import 'LrDialogs'

local exportServiceProvider = {}



function exportServiceProvider.processRenderedPhotos(functionContext, exportContext)
    local exportSession = exportContext.exportSession
    local nPhotos = exportSession:countRenditions()
    local importedCount = 0
    local failedCount = 0
    local failureMessages = {}

    -- Set a fixed export location for handoff to Photos.
    local LrPathUtils = import 'LrPathUtils'
    local LrFileUtils = import 'LrFileUtils'
    local home = LrPathUtils.getStandardFilePath('home')
    local exportDir = home .. "/Pictures/LightroomToApplePhotosTemp"
    LrFileUtils.createAllDirectories(exportDir)

    for _, rendition in exportSession:renditions{ stopIfCanceled = true } do
        local success, pathOrMessage = rendition:waitForRender()
        if not success then
            failedCount = failedCount + 1
            table.insert(failureMessages, tostring(pathOrMessage))
        else
            local photoPath = pathOrMessage
            local fileName = photoPath:match("[^/]+$")
            local destPath = exportDir .. "/" .. fileName

            local moved, moveErr = pcall(function()
                LrFileUtils.move(photoPath, destPath)
            end)

            if not moved then
                failedCount = failedCount + 1
                table.insert(failureMessages, "Failed to stage file for Photos import: " .. tostring(moveErr))
            else
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

                local tempScriptPath = os.tmpname() .. ".applescript"
                local scriptFile, openErr = io.open(tempScriptPath, "w")
                if not scriptFile then
                    failedCount = failedCount + 1
                    table.insert(failureMessages, "Failed to create AppleScript file: " .. tostring(openErr))
                else
                    scriptFile:write(script)
                    scriptFile:close()

                    local command = string.format('osascript %q %q %q', tempScriptPath, destPath, albumName)
                    local result = LrTasks.execute(command)
                    LrFileUtils.delete(tempScriptPath)

                    if result == 0 then
                        importedCount = importedCount + 1
                        LrFileUtils.delete(destPath)
                    else
                        failedCount = failedCount + 1
                        table.insert(failureMessages, "Apple Photos import failed for file: " .. tostring(destPath))
                    end
                end
            end
        end
    end

    if failedCount > 0 then
        local summary = string.format("Imported %d of %d photo(s). %d failed.", importedCount, nPhotos, failedCount)
        local details = table.concat(failureMessages, "\n")
        LrDialogs.message("Apple Photos Plugin", summary .. "\n\n" .. details, "warning")
    else
        LrDialogs.message("Apple Photos Plugin", "Imported " .. importedCount .. " photo(s) to Apple Photos.")
    end
end

return exportServiceProvider
