import solidPlugin from "vite-plugin-solid";
import tsconfigPaths from "vite-tsconfig-paths";
import { defineConfig } from "vitest/config";

export default defineConfig({
  plugins: [solidPlugin(), tsconfigPaths()],
  test: {
    globals: true,
    environment: "jsdom",
    ui: true,
  },
});
