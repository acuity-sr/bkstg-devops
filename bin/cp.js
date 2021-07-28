const fs = require("fs");
const path = require("path");

/** copies files to generated location ('scripts'), scripts directory to have zero dependencies */
function main(subDir) {
  fs.mkdirSync(`${subDir}/bin`, { recursive: true });
  [
    "decrypt.js",
    "encrypt.js",
    "read.js",
    "mute-stream.js",
    "chmod.js",
    "configMapVersion.js",
    "save-env.js",
    "run.js",
  ].forEach((f) => {
    fs.copyFileSync(`bin/${f}`, `${subDir}/bin/${f}`);
  });
}

if (require.main === module) {
  const subDir = process.argv[2];
  if (subDir && subDir !== "-h" && subDir !== "--help") {
    main(subDir);
  } else {
    console.log(
      [
        `\ncopies 'bin/*.js' to ${subDir}/bin/.`,
        `  Usage:  node ${path.basename(process.argv[1])} <subDir>`,
      ].join("\n")
    );
  }
}
