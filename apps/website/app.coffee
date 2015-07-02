express = require 'express'
favicon = require 'express-favicon'
errorhandler = require 'errorhandler'
body_parser = require 'body-parser'
cookie_parser = require 'cookie-parser'
method_override = require 'method-override'
config = require '../../config'
time = require '../../time'
shared_session = require '../shared_session'
game_app = require '../game/app'
management_app = require '../manage/app'
routes = require('require-directory')(module, "#{__dirname}/routes")

app = module.exports = express()
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'

app.use '/game', game_app
app.use '/manage', management_app
app.use favicon "#{__dirname}/public/favicon.ico"
app.use express.static "#{__dirname}/public"

app.use body_parser.urlencoded()
app.use body_parser.json()
app.use method_override()
app.use cookie_parser()
app.use shared_session

app.use (req, res, next) ->
  req.time = time()
  res.locals.time = req.time
  next()

app.use (req, res, next) ->
  res.locals.logged_in = req.session.character?
  next()

router = express.Router()
app.use router
route router for key, route of routes

app.use(errorhandler(
  dumpExceptions: config.production
  showStack: config.production
))
