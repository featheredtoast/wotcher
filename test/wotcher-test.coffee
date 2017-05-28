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
        ['hubot', '@alice `1d1` = (1) = 1']
      ]

  it 'listens', ->
    @room.user.say('alice', '/r d1').then =>
      expect(@room.messages).to.eql [
        ['alice', '/r d1']
        ['hubot', '@alice `1d1` = (1) = 1']
      ]

  it 'is case insensitive', ->
    @room.user.say('alice', 'Roll d1').then =>
      expect(@room.messages).to.eql [
        ['alice', 'Roll d1']
        ['hubot', '@alice `1d1` = (1) = 1']
      ]

  it 'does multiple dice and modifiers', ->
    @room.user.say('alice', '@hubot roll 2d1+ 2').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot roll 2d1+ 2']
        ['hubot', '@alice `2d1+2` = (1 + 1 + 2) = 4']
      ]

  it 'can comment rolls', ->
    @room.user.say('alice', 'roll 2d1+2 #my awesome roll').then =>
      expect(@room.messages).to.eql [
        ['alice', 'roll 2d1+2 #my awesome roll']
        ['hubot', '@alice `2d1+2` my awesome roll = (1 + 1 + 2) = 4']
      ]

  it 'can replay rolls', ->
    @room.user.say('alice', '/r $test 2d1+2 #my awesome roll').then =>
      expect(@room.messages).to.eql [
        ['alice', '/r $test 2d1+2 #my awesome roll']
        ['hubot', '@alice `2d1+2` my awesome roll = (1 + 1 + 2) = 4,Roll saved.']
      ]

  it 'can replay multiple rolls', ->
    @room.user.say('alice', '/r $test 2d1+2 #my awesome roll').then =>
      @room.user.say('alice', '/r $test').then =>
        expect(@room.messages).to.eql [
          ['alice', '/r $test 2d1+2 #my awesome roll']
          ['hubot', '@alice `2d1+2` my awesome roll = (1 + 1 + 2) = 4,Roll saved.']
          ['alice', '/r $test']
          ['hubot', '@alice `2d1+2` my awesome roll = (1 + 1 + 2) = 4']
        ]
