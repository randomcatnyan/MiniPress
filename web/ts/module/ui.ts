import Handlebars from 'handlebars';
import { Article, Categorie, ArticleComplet } from './types';
import { loadArticleComplet, loadArticlesByCategorie, loadArticlesByAuteur} from './articleloader';

    let articlesActuels: Article[] = [];
export function displayArticle(articles: Article[]): void {
    articlesActuels = articles;
    const templateScript = document.getElementById('ArticleTemplate') as HTMLElement;
    const template = Handlebars.compile(templateScript.innerHTML);

    const section = document.getElementById('Article') as HTMLElement;
    section.innerHTML = template({ articles: articles });

    section.addEventListener('click', (e) => {
        const cibleauteur= (e.target as HTMLElement).closest('.auteurName') as HTMLElement | null;
        if (cibleauteur) {
            e.preventDefault();
            e.stopPropagation();
            const idAuteur = Number(cibleauteur.dataset.id);
            loadArticlesByAuteur(idAuteur).then(displayArticle);
            return;
        }
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

export function tri(): void {
    const selectTri = document.getElementById('tri-date') as HTMLSelectElement;

    if (selectTri) {
        selectTri.addEventListener('change', () => {
            const ordre = selectTri.value.trim().toLowerCase();
            let articlesTries = [...articlesActuels];
            if (articlesTries.length === 0) return;
            if (ordre === 'asc') {
                articlesTries.sort((a, b) => {
                    if (a.cree < b.cree) return -1;
                    if (a.cree > b.cree) return 1;
                    return 0;
                });
            } else if (ordre === 'desc') {
                articlesTries.sort((a, b) => {
                    if (a.cree > b.cree) return -1;
                    if (a.cree < b.cree) return 1;
                    return 0;
                });
            }
            displayArticle(articlesTries);
        });
    }
}

export function filtre(): void {
    const rech = document.getElementById('recherche') as HTMLInputElement | null;
    if (rech) {
        rech.addEventListener('input', () => {
            const mot = rech.value.trim().toLowerCase();
            if (mot === "") {
                displayArticle(articlesActuels);
                return;
            }
            const filtre = articlesActuels.filter(article => {
                const titre = article.titre.toLowerCase().includes(mot);
                return titre;
            });
            const templateScript = document.getElementById('ArticleTemplate') as HTMLElement;
            const template = Handlebars.compile(templateScript.innerHTML);
            const section = document.getElementById('Article') as HTMLElement;
            section.innerHTML = template({ articles: filtre });
        });
    }
}