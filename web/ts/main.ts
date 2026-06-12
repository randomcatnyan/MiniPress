
import { loadArticles } from './module/articleloader';
import { displayArticle } from './module/ui';

// https://esbuild.github.io/api/#live-reload
// cette ligne sert à avoir un live reload pendant le dev
new EventSource('/esbuild').addEventListener('change', () => location.reload())

console.log('ss');

let p = document.querySelector('p');
if (p) p.textContent = 'aadsdda';

document.addEventListener('DOMContentLoaded', () => {
    loadArticles().then((articles: any) => displayArticle(articles))
});