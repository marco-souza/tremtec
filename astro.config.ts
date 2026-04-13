import cloudflare from "@astrojs/cloudflare";
import sitemap from "@astrojs/sitemap";
import tailwindcss from "@tailwindcss/vite";
import { defineConfig, fontProviders } from "astro/config";
import icon from "astro-icon";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const site = process.env.BASE_URL || "https://tremtec.com";

// https://astro.build/config
export default defineConfig({
  site,
  adapter: cloudflare({
    prerenderEnvironment: "node",
  }),

  integrations: [sitemap(), icon()],

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
    plugins: [tailwindcss()],
  },
});
