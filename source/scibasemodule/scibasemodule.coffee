# export name = "scibasemodule"
# ############################################################
# #region printLogFunctions
# log = (arg) ->
#     if allModules.debugmodule.modulesToDebug["scibasemodule"]?  then console.log "[scibasemodule]: " + arg
#     return
# ostr = (obj) -> JSON.stringify(obj, null, 4)
# olog = (obj) -> log "\n" + ostr(obj)
# print = (arg) -> console.log(arg)
# #endregion

# ############################################################
# export initialize = ->
#     log "scibasemodule.initialize"
#     #Implement or Remove :-)
#     return
    



Object.defineProperty(exports, "__esModule", { value: true })





############################################################
require('systemd')
express = require('express')
bodyParser = require('body-parser')
expressWS = require('express-ws')


############################################################
#region internalProperties
routes = null
port = null

############################################################
app = express()
# appWS = expressWS(app)
app = expressWS(app)
app.use bodyParser.urlencoded(extended: false)
app.use bodyParser.json()
#endregion


#################################################################
mountMiddleWare = (middleWare) ->
    if typeof middleWare ==  "function"
        app.use middleWare
        return
    if middleWare.length?
        app.use fun for fun in middleWare
        return
    return

############################################################
attachSCIFunctions = ->
    app.post("/"+route,fun) for route,fun of routes
    return

#################################################################
listenForRequests = ->
    if process.env.SOCKETMODE then app.listen "systemd"
    else app.listen port
    return

############################################################
exports.prepareAndExpose = (middleWare, leRoutes, lePort = 3333) ->
    throw new Error("No routes Object provided!") unless typeof leRoutes == "object"
    
    routes = leRoutes
    port = process.env.PORT || lePort

    if middleWare? then mountMiddleWare(middleWare)

    attachSCIFunctions()
    listenForRequests()
    return