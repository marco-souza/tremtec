import rss from "@astrojs/rss";
import type { APIRoute } from "astro";
import { getCollection } from "astro:content";

export const GET: APIRoute = async (context) => {
  const posts = await getCollection("blog");

  return rss({
    title: "TremTec Blog",
    description:
      "Engineering insights on AI-driven development, team scaling, and building trustworthy software faster.",
    site: context.site?.href || "https://tremtec.com",
    items: posts.map((post) => ({
      title: post.data.title,
      pubDate: post.data.date,
      description: post.data.description,
      link: `/blog/${post.id}/`,
    })),
    customData: `<language>en-us</language>`,
  });
};
