#!/usr/bin/env node

var fs = require('fs'),
    path = require('path');

module.exports = function (context) {
    var deferred = new context.requireCordovaModule('q').defer(),
        src = path.resolve(context.opts.plugin.dir, 'www'),
        dst = path.resolve(context.opts.projectRoot, 'www', 'lib/angular-admob');

    ensureExists(context, dst, function (err) {
        if (!err) {
            copyFile(context, src, dst, deferred.resolve);
        }
    });

    return deferred.promise;
};

function copyFile(context, src, dst, done) {
    var ws, rs,
        cbCalled = false;

    rs = fs.createReadStream(path.resolve(src, 'angular-admob.js'));
    ws = fs.createWriteStream(path.resolve(dst, 'angular-admob.js'));
    rs.on("error", _done);
    ws.on("error", _done);
    ws.on("close", _done);
    rs.pipe(ws);

    function _done(err) {
        if (err) {
            showErrorNotice(context, err);
        }
        if (!cbCalled) {
            done();
        }
    }
}

function showErrorNotice(context, err) {
    console.log("\x1b[31m\x1b[1mcordova-admob:\x1b[22m \x1b[93m Warning, could not copy necessary files for angular browser platform.");
    if (err) {
        console.log();
        console.log(err);
        console.log();
    }
    console.log("\x1b[31m\x1b[1mcordova-admob:\x1b[22m \x1b[93m Please ensure `www/lib/angular-admob/angular-admob.js` exists (you can copy it from `plugins/" + context.opts.plugin.id + "/angular-admob.js`)");
}

function ensureExists(context, path, mask, cb) {
    if (typeof mask == 'function') { // allow the `mask` parameter to be optional
        cb = mask;
        mask = 0777;
    }
    fs.mkdir(path, mask, function (err) {
        if (err) {
            if (err.code == 'EEXIST') {
                cb(null); // ignore the error if the folder already exists
            } else {
                cb(err); // something else went wrong
                showErrorNotice(context);
            }
        } else {
            cb(null); // successfully created folder
        }
    });
}
