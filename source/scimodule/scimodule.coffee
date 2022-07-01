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
import { validate as validateUUID } from 'uuid'

#endregion

WSHandle = null

############################################################
clientIdCount = 0

clientIdtoUUID = {}
uuidToConnection = {}


############################################################
class SocketConnection
    constructor: (@socket, @clientId) ->
        # preseve that "this" is this class
        self = this
        @socket.onmessage = (evnt) -> self.onMessage(evnt)
        @socket.onclose = (evnt) -> self.onDisconnect(evnt)
        log "#{@clientId} connected!"
        @uuid = "none"

    onMessage: (evnt) ->
        log "onMessage"
        try
            message = evnt.data
            log "#{message}"
            
            commandEnd = message.indexOf(" ")
            if commandEnd < 0 then command = message
            else
                command = message.substring(0, commandEnd)
                postCommand = message.substring(commandEnd).trim()

            switch command
                when "setuuid" then @setUUID(postCommand)
                when "to" then messageTo(postCommand)
                when "getalluuids" then @socket.send("alluids #{Object.keys(uuidToConnection)}")
                else throw new Error("unknown command: #{command}")

        catch err then log err
        return

    onDisconnect: (evnt) ->
        log "onDisconnect: #{@clientId}"
        try
            delete clientIdtoUUID[@clientId]
            delete uuidToConnection[@uuid]
            for uuid,connection of uuidToConnection when uuid != @uuid
               connection.sendMessage("uuidremoved #{@uuid}")
             
        catch err then log err
        return

    setUUID: (uuid) ->
        throw new Error("Invalid UUID") unless validateUUID(uuid)
        throw new Error("UUID already taken!") if uuidToConnection[uuid]?
        if @uuid != "none" then delete uuidToConnection[@uuid]

        @uuid = uuid
        clientIdtoUUID[@clientId] = uuid
        uuidToConnection[uuid] = this

        for uuid,connection of uuidToConnection when uuid != @uuid
            connection.sendMessage("uuidadded #{@uuid}")

        return
    
    sendMessage: (message) -> @socket.send(message)


############################################################


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
    conn = new SocketConnection(socket, "#{clientIdCount}")
    clientIdCount++
    return

############################################################
export prepareAndExpose = ->
    log "scimodule.prepareAndExpose"
    # handlers.setService(this)
    sciBase.prepareAndExpose(null, routes)
    sciBase.onWebsocketConnect("/", onConnect)
    WSHandle = sciBase.getWSHandle()
    return

############################################################
# authenticate = 
