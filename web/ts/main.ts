import { loadArticles } from './module/articleloader';
import { displayArticle } from './module/ui';

document.addEventListener('DOMContentLoaded', () => {
    loadArticles().then((articles: any) => displayArticle(articles))
});