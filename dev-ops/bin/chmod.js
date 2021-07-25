const fs = require("fs");

/** copies and chmods files as needed, to enable scripts directory to have zero dependencies */
function main(subDir) {
  fs.readdirSync(`./${subDir}/nix`).forEach((f) => {
    fs.chmodSync(`./${subDir}/nix/${f}`, 0755);
  });
}

if (require.main === module) {
  const subDir = process.argv[2];
  main(subDir);
}
