import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const blog = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/blog' }),
  schema: z.object({
    title: z.string(),
    date: z.coerce.date(),
    category: z.enum(['News', 'Knowledge', 'Analysis']),
    summary: z.string(),
    thumbnail: z.string().optional(),
    author: z.string().default('CryptoVibe Team'),
  }),
});

export const collections = { blog };
