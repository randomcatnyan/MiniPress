import Handlebars from 'handlebars';
import { Article, Categorie, ArticleComplet } from './types';
import { loadArticleComplet, loadArticlesByCategorie } from './articleloader';

let articlesActuels: Article[] = [];
export function displayArticle(articles: Article[]): void {
    articlesActuels = articles;
    const templateScript = document.getElementById('ArticleTemplate') as HTMLElement;
    const template = Handlebars.compile(templateScript.innerHTML);

    const section = document.getElementById('Article') as HTMLElement;
    section.innerHTML = template({ articles: articles });

    section.addEventListener('click', (e) => {
        const cible = (e.target as HTMLElement).closest('[data-lien]') as HTMLElement | null;
        if (!cible) return;
        e.preventDefault();
        const lien = cible.dataset.lien!;
        loadArticleComplet(lien).then(displayArticleComplet);
});
}

export function displayCategories(categories: Categorie[]): void {
    const templateScript = document.getElementById('cate') as HTMLElement;
    const template = Handlebars.compile(templateScript.innerHTML);

    const section = document.getElementById('categories') as HTMLElement;
    section.innerHTML = template({ categories: categories });

    section.addEventListener('click', (e) => {
        const cible = (e.target as HTMLElement).closest('.categorie-item') as HTMLElement | null;
        if (!cible) return;
        e.preventDefault();
        const id = Number(cible.dataset.id);
        loadArticlesByCategorie(id).then(displayArticle);
    });
}

export function displayArticleComplet(article: ArticleComplet){
    const templateScript = document.getElementById('ArticleCompletTemplate') as HTMLElement;
    const template = Handlebars.compile(templateScript.innerHTML);

    const section = document.getElementById('Article') as HTMLElement;
    section.innerHTML = template({
        titre:   article.titre,
        cree:    article.cree,
        auteur:  article.auteur.nom,
        resume:  article.resume ?? '',  
        contenu: article.contenu ?? '',  
    });
}

