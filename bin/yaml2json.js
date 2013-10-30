#!/usr/bin/env node

"use strict";

pgmArgs = require('../lib/yaml2json/cli');

require('../lib').yaml2json(pgmArgs, function (exitCode) {
    process.exit(exitCode);
});
