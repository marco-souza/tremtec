import * as cloudflare from "@pulumi/cloudflare";
import * as command from "@pulumi/command";
import * as pulumi from "@pulumi/pulumi";
import * as child_process from "node:child_process";

const config = new pulumi.Config();
const environment = config.require("environment");
const accountId = config.require("accountId");

const secrets = {
  github: {
    id: config.requireSecret("github-id"),
    secret: config.requireSecret("github-secret"),
  },
  google: {
    id: config.requireSecret("google-id"),
    secret: config.requireSecret("google-secret"),
  },
};

const today = () => new Date().toISOString().split("T")[0];

const absolutePath = (relativePath: string) =>
  new URL(relativePath, import.meta.url).pathname;

const gitCommitHash = child_process
  .execSync("git rev-parse HEAD", { encoding: "utf-8" })
  .trim();

const buildCommand = pulumi.interpolate`bun run build && bun w build`;
const builder = new command.local.Command("website-build", {
  dir: absolutePath(".."),
  create: buildCommand,
  update: buildCommand,
  environment: {
    NODE_ENV: "production",
  },
  triggers: [gitCommitHash],
});

const worker = new cloudflare.Worker(`tremtec-${environment}`, {
  accountId,
  name: `tremtec-${environment}`,

  subdomain: {
    enabled: true,
  },

  tags: ["tremtec", environment],

  observability: {
    enabled: true,
    headSamplingRate: 1.0,

    logs: {
      enabled: true,
      headSamplingRate: 1.0,
    },
  },
});

const baseUrl = pulumi.interpolate`https://${worker.name}.tremtec.workers.dev`;

const workerVersion = new cloudflare.WorkerVersion(
  `tremtec-worker-version-${environment}`,
  {
    accountId,
    workerId: worker.id,
    mainModule: "index.js",
    compatibilityDate: today(), // "2026-02-03",
    compatibilityFlags: ["global_fetch_strictly_public", "nodejs_compat"],

    assets: {
      directory: absolutePath("../dist/"),
      config: {
        runWorkerFirst: false,
      },
    },

    bindings: [
      {
        type: "assets",
        name: "ASSETS",
      },

      // env vars
      {
        name: "BASE_URL",
        type: "plain_text",
        text: baseUrl,
      },
      {
        name: "GITHUB_ID",
        type: "secret_text",
        secretName: "github-id",
        text: secrets.github.id,
      },
      {
        name: "GITHUB_SECRET",
        type: "secret_text",
        secretName: "github-secret",
        text: secrets.github.secret,
      },
      {
        name: "GOOGLE_ID",
        type: "secret_text",
        secretName: "google-id",
        text: secrets.google.id,
      },
      {
        name: "GOOGLE_SECRET",
        type: "secret_text",
        secretName: "google-secret",
        text: secrets.google.secret,
      },
    ],

    modules: [
      {
        name: "index.js",
        contentFile: absolutePath("../dist/index.js"),
        contentType: "application/javascript+module",
      },
    ],
  },
  {
    dependsOn: [worker, builder],
  },
);

const workerDeployment = new cloudflare.WorkersDeployment(
  `tremtec-worker-deployment-${environment}`,
  {
    accountId,
    versions: [
      {
        versionId: workerVersion.id,
        percentage: 100,
      },
    ],
    scriptName: worker.name,
    strategy: "percentage",
  },
  {
    dependsOn: [workerVersion],
  },
);

export const domain = baseUrl;
export const workerScriptName = workerDeployment.scriptName;
