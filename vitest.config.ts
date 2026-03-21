import tsconfigPaths from "vite-tsconfig-paths";
import { defineConfig } from "vitest/config";

export default defineConfig({
  plugins: [tsconfigPaths()],
  test: {
    globals: true,
    environment: "jsdom",
    ui: true,
  },
  resolve: {
    alias: {
      // Stub Cloudflare-specific modules for Node.js testing environment
      "cloudflare:email": "/src/lib/__mocks__/cloudflare-email.ts",
    },
  },
});
