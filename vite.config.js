import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { writeFileSync } from 'fs';
import { resolve } from 'path';

const repoName = process.env.GITHUB_REPOSITORY?.split('/')[1];
const base = repoName ? `/${repoName}/` : '/';
const ICON_VERSION = '5';

function abs(path) {
  return `${base}${path}`;
}

export default defineConfig({
  base,
  plugins: [
    react(),
    {
      name: 'pwa-assets',
      transformIndexHtml(html) {
        return html
          .replace(
            'href="manifest.webmanifest?v=4"',
            `href="${abs(`manifest.webmanifest?v=${ICON_VERSION}`)}"`,
          )
          .replace(
            /href="icon-homescreen\.png"/g,
            `href="${abs(`icon-homescreen.png?v=${ICON_VERSION}`)}"`,
          );
      },
      closeBundle() {
        const manifest = {
          id: `https://lukebanton.github.io/Audio-Calc/?app=${ICON_VERSION}`,
          name: 'Audio Calc',
          short_name: 'Audio Calc',
          description: 'Audio engineering calculator — distance, latency, and frames.',
          start_url: `${abs(`?app=${ICON_VERSION}`)}`,
          display: 'standalone',
          background_color: '#F2F2F7',
          theme_color: '#F2F2F7',
          orientation: 'portrait',
          icons: [
            {
              src: abs(`icon-homescreen.png?v=${ICON_VERSION}`),
              sizes: '180x180',
              type: 'image/png',
              purpose: 'any',
            },
            {
              src: abs(`icon-192.png?v=${ICON_VERSION}`),
              sizes: '192x192',
              type: 'image/png',
              purpose: 'any',
            },
            {
              src: abs(`icon-512.png?v=${ICON_VERSION}`),
              sizes: '512x512',
              type: 'image/png',
              purpose: 'any',
            },
          ],
        };

        writeFileSync(
          resolve('dist', 'manifest.webmanifest'),
          `${JSON.stringify(manifest, null, 2)}\n`,
        );
      },
    },
  ],
});
