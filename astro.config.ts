import cloudflare from "@astrojs/cloudflare";
import { defineConfig, fontProviders } from "astro/config";
import icon from "astro-icon";
import path from "node:path";
import { fileURLToPath } from "node:url";
import tailwindcss from "@tailwindcss/vite";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// https://astro.build/config
export default defineConfig({
  adapter: cloudflare({
    prerenderEnvironment: "node",
  }),

  integrations: [icon()],

  fonts: [
    {
      name: "Inter",
      cssVariable: "--font-inter",
      provider: fontProviders.fontsource(),
    },
  ],

  security: {
    csp: true,
  },

  vite: {
    define: {
      // Force debug package to use browser detection
      "process.browser": true,
    },
    resolve: {
      alias: {
        // Map debug to a no-op ESM module to avoid CommonJS issues
        debug: path.resolve(__dirname, "src/lib/debug-shim.js"),
      },
    },
    plugins: [
      // @ts-expect-error Reason: interface issue with tailwindcss plugin
      tailwindcss(),
    ],
  },
});
