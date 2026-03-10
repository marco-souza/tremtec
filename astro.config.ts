import solidJs from "@astrojs/solid-js";
import tailwindcss from "@tailwindcss/vite";
import { defineConfig } from "astro/config";
import icon from "astro-icon";

// https://astro.build/config
export default defineConfig({
  output: "static",
  integrations: [solidJs(), icon()],

  vite: {
    plugins: [tailwindcss({ optimize: true })],
  },
});
