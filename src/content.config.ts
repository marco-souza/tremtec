import { defineCollection } from "astro/content/config";
import { file, glob } from "astro/loaders";
import { z } from "astro/zod";

const blogSchema = z.object({
  title: z.string().min(3),
  description: z.string().optional(),
  date: z.coerce.date().optional(),
  author: z.string().optional(),
  tags: z.array(z.string()).optional(),
  permalink: z.string().optional(),
});

const blog = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/blog" }),
  schema: blogSchema,
});

const productSchema = z.object({
  name: z.string().min(3),
  description: z.string().min(3),
  techStack: z.array(z.string()).min(1),
});

const products = defineCollection({
  loader: file("./src/content/products.json"),
  schema: productSchema,
});

// Expose your defined collection to Astro
// with the `collections` export
export const collections = {
  // TODO: add page content
  blog,
  products,
};
