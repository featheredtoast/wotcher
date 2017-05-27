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
    @room = rollingHelper.createRoom()

  afterEach ->
    @room.destroy()

  it 'does single dice', ->
    @room.user.say('alice', '@hubot roll d1').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot roll d1']
        ['hubot', '@alice Rolled 1']
      ]

  it 'does multiple dice and modifiers', ->
    @room.user.say('alice', '@hubot roll 2d1+ 2').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot roll 2d1+ 2']
        ['hubot', '@alice Rolled 1 + 1 + 2 = 4']
      ]
