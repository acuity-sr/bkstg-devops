/**
 * Hacky way to encrypting some secrets to speed development of POC.
 *
 * Please, PLEASE do something - anything - so this does not make it to production.
 * With that, this poor soul will continue on with the hack...
 *
 */

const fs = require("fs");
exports.saveEnv = (fname, creds) => {
  const s =
    process.platform === "win32"
      ? [
          `set SP_CLIENT_ID=${creds.clientId}`,
          `set SP_CLIENT_SECRET=${creds.clientSecret}`,
        ].join("\n")
      : [
          `SP_CLIENT_ID=${creds.clientId}`,
          `SP_CLIENT_SECRET=${creds.clientSecret}`,
        ].join("\n");
  fs.writeFileSync(fname, s, "utf8");
  console.log("env file created");
};
