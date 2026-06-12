import Handlebars from 'handlebars';
import { Article } from './types';

export function displayArticle(articles: Article[]): void {
    const templateScript = document.getElementById('ArticleTemplate') as HTMLElement;
    const template = Handlebars.compile(templateScript.innerHTML);

    const section = document.getElementById('Article') as HTMLElement;
    section.innerHTML = template({ articles: articles });
}