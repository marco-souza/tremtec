import cloudflare from "@astrojs/cloudflare";
import tailwindcss from "@tailwindcss/vite";
import { defineConfig, fontProviders } from "astro/config";
import icon from "astro-icon";

// https://astro.build/config
export default defineConfig({
  output: "server",
  adapter: cloudflare(),
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
    plugins: [
      // @ts-expect-error - type mismatch between tailwindcss and vite versions
      tailwindcss(),
    ],
  },
});
