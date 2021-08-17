#!/usr/local/bin node

/**
 * Hacky way to encrypting some secrets to speed development of POC.
 *
 * Please, PLEASE do something - anything - so this does not make it to production.
 * With that, this poor soul will continue on with the hack...
 *
 */

const crypto = require("crypto");
const fs = require("fs");
const read = require("./read");
const { saveEnv } = require("./save-env");

function main(fname, password) {
  const text = fs.readFileSync(fname, "utf8");
  const algorithm = "aes-256-ctr";
  const iv = crypto.randomBytes(16);
  const b64 = crypto
    .createHash("sha256")
    .update(String(password))
    .digest("base64");
  const key = Buffer.from(b64, "base64");
  const cipher = crypto.createCipheriv(algorithm, key, iv);

  const encrypted = Buffer.concat([cipher.update(text), cipher.final()]);

  fs.writeFileSync(
    fname,
    JSON.stringify({
      iv: iv.toString("hex"),
      content: encrypted.toString("hex"),
    }),
    "utf8"
  );
  saveEnv(`${fname}.env`, JSON.parse(text));
  console.log(`Successfully encrypted '${fname}'`);
}

if (require.main === module) {
  const fname = process.argv[2];
  read(
    {
      prompt: `Encrypting file '${fname}'\npassword:`,
      silent: true,
      replace: "*",
      default: "",
    },
    (password) => main(fname, password)
  );
}
