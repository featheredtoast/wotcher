// Description:
//   Get the current steam daily deal.
//
// Dependencies:
//   "cheerio": "latest"
//   "got": "latest"
//   "sanitize-html": "latest"
//
// Listens to talk about 'the deals' and gives a steam deal.
//
// Author:
//   Jeff Wong
// Forked from:
//   hubot-steamdeal
//   sebastianwachter

'use strict';

const cheerio = require('cheerio');
const got = require('got');
const sanitize = require('sanitize-html');

module.exports = (robot) => {
    robot.hear(/the deals/i, (msg) => {
        var args = msg.match[1];
        got('http://store.steampowered.com').then((res) => {
            var body = res.body;
            if (res.statusCode !== 200) return msg.send('Steam currently unavailable!');
            let $ = cheerio.load(body);
            let idAttr = $('.dailydeal_desc .dailydeal_countdown').attr('id');
            let id = idAttr.substr(idAttr.length - 6);
            msg.send("Wotcher got the deals!", `https://store.steampowered.com/app/${id}`);
        });
    });
};
