const fs = require("fs");

/** copies files to generated location ('scripts'), scripts directory to have zero dependencies */
function main(subDir) {
  fs.mkdirSync(`${subDir}/bin`, { recursive: true });
  [
    "decrypt.js",
    "encrypt.js",
    "read.js",
    "mute-stream.js",
    "chmod.js",
    "save-env.js",
    "run.js",
  ].forEach((f) => {
    fs.copyFileSync(`bin/${f}`, `${subDir}/bin/${f}`);
  });
}

if (require.main === module) {
  const subDir = process.argv[2];
  main(subDir);
}
