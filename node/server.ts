import express from 'express';
import * as cheerio from 'cheerio';
import cors from 'cors';

type Song = { id: string, title: string; artist: string; url: string }

const app = express();
const PORT = 3000;

app.use(cors());

function getId(title: string, artist: string, url: string): string {
  const match = url.match(/artist\/([^/]+)\/([^/.]+)\.html/);
  if (match) {
    return `${match[1]}/${match[2]}`;
  } else {
    return `${title}/${artist}`;
  }
}

app.get('/search', async (req, res) => {
  const query = req.query.query as string;

  if (!query) {
    res.status(400).json({ error: 'Missing search query' });
    return;
  }

  try {
    const searchUrl = `https://j-lyric.net/index.php?kt=${encodeURIComponent(query)}`;
    const response = await fetch(searchUrl);
    const html = await response.text();
    const $ = cheerio.load(html);

    const results: Song[] = [];

    $('#lyricList > .body').each((_, el) => {
      const title = $(el).find('.title a').text().trim();
      const artist = $(el).find('.status a').text().trim();
      const url = 'https://j-lyric.net' + $(el).find('.title a').attr('href');

      if (title && artist && url) {
        const id = getId(title, artist, url);
        results.push({ id, title, artist, url });
      }
    });

    res.json({ results });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch data' });
  }
});

app.get('/lyrics', async (req, res) => {
  const url = req.query.url as string;

  if (!url || !url.startsWith('https://j-lyric.net')) {
    res.status(400).json({ error: 'Invalid or missing URL' });
    return;
  }

  try {
    const response = await fetch(url);
    const html = await response.text();
    const $ = cheerio.load(html);
    const lines: string[] = [];

    $('#Lyric')[0]
      .childNodes
      .forEach(elem => {
        const raw = $(elem).text(); // získáme text z jednoho potomka
        const splitted = raw.split('\n').map(l => l.trim()).filter(l => l);
        lines.push(...splitted);
      });

    res.json({ lyrics: lines });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch lyrics' });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
