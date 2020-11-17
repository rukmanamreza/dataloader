# Because of a long-running npm issue (https://github.com/npm/npm/issues/3059)
# prepublish runs after `npm install` and `npm pack`.
# In order to only run prepublish before `npm publish`, we have to check argv.
if node -e "process.exit(($npm_config_argv).original.length > 0 && ($npm_config_argv).original[0].indexOf('pu') === 0)"; then
  exit 0;
fi

# Build before publishing
npm run build;

# When Travis CI publishes to NPM, the published files are available in the root
# directory, which produces a cleaner distribution.
#
cp dist/* .

# Ensure a vanilla package.json before deploying so other tools do not interpret
# The built output as requiring any further transformation.
node -e "var package = require('./package.json'); \
  delete package.scripts; \
  delete package.devDependencies; \
  require('fs').writeFileSync('package.json', JSON.stringify(package, null, 2));"
