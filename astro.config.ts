import cloudflare from "@astrojs/cloudflare";
import solidJs from "@astrojs/solid-js";
import tailwindcss from "@tailwindcss/vite";
import { defineConfig } from "astro/config";
import icon from "astro-icon";

// https://astro.build/config
export default defineConfig({
  output: "server",
  adapter: cloudflare(),
  integrations: [solidJs(), icon()],

  vite: {
    plugins: [
      // NOTE: type mismatch between tailwindcss and vite, but it works fine
      // @ts-expect-error
      tailwindcss({ optimize: true }),
    ],
  },
});
