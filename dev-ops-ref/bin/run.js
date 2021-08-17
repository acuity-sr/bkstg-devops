/**
 * A wrapper to provide a cross-platform method to execute platform specific shell scripts -
 * `create.{bat, sh}`, `destroy.{bat, sh}` etc. 
 *
 */

const cp = require("child_process");

if (require.main === module) {
  const mode = process.argv[2];
  const mapper = process.platform === 'win32' 
    ? {
     'create': `${__dirname}/../bat/create.bat`,
     'read': `${__dirname}/../bat/read.bat`,
     'destroy': `${__dirname}/../bat/destroy.bat`,
    } :
    {
      'create': `${__dirname}/../nix/create.sh`,
      'read': `${__dirname}/../nix/read.sh`,
      'destroy': `${__dirname}/../nix/destroy.sh`,
    }

  const supported = Object.keys(mapper);
  if (!supported.includes(mode)) {
    throw new Error(`Unsupported lifecycle method '${mode}' requested. Must be one of '${JSON.stringify(supported)}'`)
  }
  const script = mapper[mode];
  const shell = cp.spawn(script, [], { stdio: 'inherit' });
  shell.on('close', (code) => {
    if (code === 0 ) {
      console.log(`\n\n${mode} completed successfully`)
    } else {
      console.log(`code: ${code}`);
      console.log(`\n\n${mode} had failures. Please see log for details`);
    }
  })
  
}