local LrView = import 'LrView'
local bind = LrView.bind

return {
    {
        title = "Apple Photos Settings",
        synopsis = function(props)
            return "Exports will use the Lightroom folder name as the Apple Photos album name."
        end,
        f = function(viewFactory, props)
            return viewFactory:row {
                viewFactory:static_text {
                    title = "The exported photos will be imported into an Apple Photos album matching the Lightroom folder name."
                },
            }
        end,
    },
}
