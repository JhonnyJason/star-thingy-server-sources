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
# import * as sciBase from "thingy-sci-base"

# import * as routes from ""
# import * as handlers from ""

import  *  as sciBase from "./scibasemodule.js"

#endregion

clientId = 0


############################################################
class SocketConnection 
    constructor: (@socket, @clientId) ->
        # preseve that "this" is this class
        self = this
        @socket.onmessage = (evnt) -> self.onMessage(evnt)
        @socket.onclose = (evnt) -> self.onDisconnect(evnt)
        log "#{@clientId} connected!"

    onMessage: (evnt) ->
        log "onMessage: #{@clientId}"
        return

    onDisconnect: (evnt) ->
        log "onDisconnect: #{@clientId}"
        return


############################################################
routes = {
    test: (req, res) ->
        olog req.body
        responseObj = {cargo:"pong"}
        response = JSON.stringify(responseObj)
        res.end(response)
}

authenticate = (req, res, next) -> next()

onMessage = (message) -> log message

onConnect = (socket, req) ->
    conn = new SocketConnection(socket, "#{clientId}")
    clientId++
    return

############################################################
export prepareAndExpose = ->
    log "scimodule.prepareAndExpose"
    # handlers.setService(this)
    sciBase.prepareAndExpose(null, routes)
    sciBase.onWebsocketConnect("/", onConnect)
    return

############################################################
# authenticate = 
