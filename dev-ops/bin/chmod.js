const fs = require("fs");
const path = require("path");

/** chmods files as needed, to enable scripts directory to have zero dependencies */
function main(subDir) {
  fs.readdirSync(`./${subDir}/nix`).forEach((f) => {
    fs.chmodSync(`./${subDir}/nix/${f}`, 0755);
  });
}

if (require.main === module) {
  const subDir = process.argv[2];
  if (subDir && subDir !== "-h" && subDir !== "--help") {
    main(subDir);
  } else {
    console.log(
      [
        `\nSets bash scripts to be executable: chmod +x ${subDir}/nix/*`,
        `  Usage:  node ${path.basename(process.argv[1])} <subDir>`,
      ].join("\n")
    );
  }
}
