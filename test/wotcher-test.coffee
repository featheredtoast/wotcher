Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/wotcher.coffee')
rollingHelper = new Helper('../src/dice-roller.coffee')

describe 'wotcher', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'hears the deals', ->
    @room.user.say('alice', '@hubot the deals').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot the deals']
        ['hubot', 'Wotcher got the deals!']
      ]

describe 'dicer', ->
  beforeEach ->
    @roolm = rollingHelper.createRoom()

  afterEach ->
    @room.destroy()

  it 'does dice', ->
    @room.user.say('alice', '@hubot roll 1d6').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot roll 1d6']
        ['hubot', '@alice rolled 3']
      ]
