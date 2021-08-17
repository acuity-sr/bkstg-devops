const tarBundle = require('./tar-bundle');

/**
 * A simple tar clone that implements these ops:
 * 
 * tar -rf packages/backend/dist/skeleton.tar yarn.lock package.json app-config.yaml
 * tar -tvf packages/backend/dist/skeleton.tar.gz
 * tar -zcvf release/bkstg.api.tgz packages/backend/dist/* packages/backend/Dockerfile
 * tar -xvf bkstg.api.tgz
 */
function tar(opts, tarFile, ...rest) {
  throw new Error(`implement tar!`);
}

