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
  const hash = JSON.parse(fs.readFileSync(fname, "utf8"));
  const b64 = crypto
    .createHash("sha256")
    .update(String(password))
    .digest("base64");
  const key = Buffer.from(b64, "base64");
  const algorithm = "aes-256-ctr";
  const decipher = crypto.createDecipheriv(
    algorithm,
    key,
    Buffer.from(hash.iv, "hex")
  );
  const decrpyted = Buffer.concat([
    decipher.update(Buffer.from(hash.content, "hex")),
    decipher.final(),
  ]);
  const text = decrpyted.toString();
  fs.writeFileSync(`${fname}.decrypted`, text, "utf8");
  saveEnv(`${fname}.env`, JSON.parse(text));
  console.log(`Successfully decrypted '${fname}.decrypted'`);
}

if (require.main === module) {
  const fname = process.argv[2];
  read(
    {
      prompt: `Decrypting file '${fname}'\npassword:`,
      silent: true,
      replace: "*",
      default: "",
    },
    (password) => main(fname, password)
  );
}
