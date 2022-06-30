############################################################
sci = null

############################################################
export initialize = ->
    sci = allModules.scimodule
    return

############################################################
export serviceStartup = ->
    sci.prepareAndExpose()
    return
