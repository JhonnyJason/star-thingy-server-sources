############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["scimodule"]?  then console.log "[scimodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region modules from the Environment
import * as sciBase from "thingy-sci-base"
# import * as routes from ""
# import * as handlers from ""
#endregion

############################################################
export prepareAndExpose = ->
    log "scimodule.prepareAndExpose"
    # handlers.setService(this)
    # sciBase.prepareAndExpose(authenticate, routes)
    return

############################################################
# authenticate = 
