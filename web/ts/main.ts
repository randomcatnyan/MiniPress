import { loadArticles } from './articleloader';
import { displayArticle } from './ui';

document.addEventListener('DOMContentLoaded', () => {
    loadArticles().then((articles: any) => displayArticle(articles))
});