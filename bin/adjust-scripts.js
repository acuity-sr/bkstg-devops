const fs = require("fs");

/** copies and chmods files as needed, to enable scripts directory to have zero dependencies */
function main() {
  fs.mkdirSync("./scripts/bin", { recursive: true });
  ["decrypt.js", "encrypt.js", "read.js"].forEach((f) => {
    fs.copyFileSync(`bin/${f}`, `scripts/bin/${f}`);
  });
  fs.readdirSync("./scripts/nix").forEach((f) => {
    fs.chmodSync(`./scripts/nix/${f}`, 0755)
  })
}

main();
