const fs = require("fs");
const path = require("path");

function main(fname) {
  const contents = fs
    .readFileSync(fname, "utf8")
    .replace(/\r\n/g, "\n")
    .split("\n")
    .map((line) => {
      const match = line.match(/configMapVersion\s*:\s*v(\d+)/);
      if (match) {
        const prev = parseInt(match[1]);
        const next = prev + 1;
        return line.replace(
          /(\s*)configMapVersion\s*:\s*v(\d+)/,
          `$1configMapVersion: v${next}`
        );
      } else {
        return line;
      }
    })
    .join("\n");
  fs.writeFileSync(fname, contents, "utf8");
}

if (require.main === module) {
  const fname = process.argv[2];
  if (fname && fname !== "-h" && fname !== "--help") {
    main(fname);
  } else {
    console.log(
      [
        `\nIncrements 'configMapVersion' (if found)`,
        `  Usage:  node ${path.basename(process.argv[1])} <deployment.yml>`,
      ].join("\n")
    );
  }
}
