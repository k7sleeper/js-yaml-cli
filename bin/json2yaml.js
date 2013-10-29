#!/usr/bin/env node

pgmArgs = require('../lib/json2yaml/cli');

require('../lib').json2yaml(pgmArgs, function(exitCode) {
    process.exit(exitCode);
});
