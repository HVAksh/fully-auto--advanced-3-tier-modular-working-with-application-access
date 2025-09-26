import { defineConfig } from "eslint";
import js from "@eslint/js";
import globals from "globals";
import tsPlugin from "@typescript-eslint/eslint-plugin";
import reactPlugin from "eslint-plugin-react";

export default defineConfig([
  {
    files: ["**/*.{js,mjs,cjs}"],
    languageOptions: {
      globals: globals.browser,
      parserOptions: { ecmaVersion: 2020, sourceType: "module" },
    },
    plugins: { js },
    rules: {
      ...js.configs.recommended.rules,
    },
  },
  {
    files: ["**/*.{ts,tsx,mts,cts}"],
    languageOptions: {
      parser: "@typescript-eslint/parser",
      parserOptions: { ecmaVersion: 2020, sourceType: "module" },
    },
    plugins: { tsPlugin, reactPlugin },
    rules: {
      ...tsPlugin.configs.recommended.rules,
      ...reactPlugin.configs.recommended.rules,
    },
  },
]);
