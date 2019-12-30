const Helper = require("hubot-test-helper");
const chai = require("chai");

const { expect } = chai;

const helper = new Helper("../src/wotcher.js");
const rollingHelper = new Helper("../src/dice-roller.coffee");

describe("wotcher", function() {
  beforeEach(function() {
    this.room = helper.createRoom();
  });

  afterEach(function() {
    this.room.destroy();
  });

  it("hears the deals", function() {
    this.room.user.say("alice", "@hubot the deals").then(() => {
      expect(this.room.messages).to.eql([
        ["alice", "@hubot the deals"],
        ["hubot", "Wotcher got the deals!"]
      ]);
    });
  });
});

describe("dicer", function() {
  beforeEach(function() {
    this.room = rollingHelper.createRoom();
  });

  afterEach(function() {
    this.room.destroy();
  });

  it("does single dice", function() {
    this.room.user.say("alice", "@hubot roll d1").then(() => {
      expect(this.room.messages).to.eql([
        ["alice", "@hubot roll d1"],
        ["hubot", "@alice `1d1` = (1) = 1"]
      ]);
    });
  });

  it("listens", function() {
    this.room.user.say("alice", "/r d1").then(() => {
      expect(this.room.messages).to.eql([
        ["alice", "/r d1"],
        ["hubot", "@alice `1d1` = (1) = 1"]
      ]);
    });
  });

  it("is case insensitive", function() {
    this.room.user.say("alice", "Roll d1").then(() => {
      expect(this.room.messages).to.eql([
        ["alice", "Roll d1"],
        ["hubot", "@alice `1d1` = (1) = 1"]
      ]);
    });
  });

  it("does multiple dice and modifiers", function() {
    this.room.user.say("alice", "@hubot roll 2d1+ 2").then(() => {
      expect(this.room.messages).to.eql([
        ["alice", "@hubot roll 2d1+ 2"],
        ["hubot", "@alice `2d1+2` = (1 + 1 + 2) = 4"]
      ]);
    });
  });

  it("can comment rolls", function() {
    this.room.user.say("alice", "roll 2d1+2 #my awesome roll").then(() => {
      expect(this.room.messages).to.eql([
        ["alice", "roll 2d1+2 #my awesome roll"],
        ["hubot", "@alice `2d1+2` my awesome roll = (1 + 1 + 2) = 4"]
      ]);
    });
  });

  it("can replay rolls", function() {
    this.room.user.say("alice", "/r $test 2d1+2 #my awesome roll").then(() => {
      expect(this.room.messages).to.eql([
        ["alice", "/r $test 2d1+2 #my awesome roll"],
        ["hubot", "@alice `2d1+2` my awesome roll = (1 + 1 + 2) = 4"],
        ["hubot", "@alice Roll saved."]
      ]);
    });
  });

  it("can replay multiple rolls", function() {
    this.room.user.say("alice", "/r $test 2d1+2 #my awesome roll").then(() => {
      this.room.user.say("alice", "/r $test").then(() => {
        expect(this.room.messages).to.eql([
          ["alice", "/r $test 2d1+2 #my awesome roll"],
          ["hubot", "@alice `2d1+2` my awesome roll = (1 + 1 + 2) = 4"],
          ["hubot", "@alice Roll saved."],
          ["alice", "/r $test"],
          ["hubot", "@alice `2d1+2` my awesome roll = (1 + 1 + 2) = 4"]
        ]);
      });
    });
  });
});
