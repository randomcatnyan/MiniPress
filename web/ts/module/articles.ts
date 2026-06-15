import { Article } from './types';

export function tri(articles: Article[], ordre: 'asc' | 'desc'): Article[] {
    return [...articles].sort((a, b) => {
        if (ordre === 'asc') return a.cree < b.cree ? -1 : a.cree > b.cree ? 1 : 0;
        return a.cree > b.cree ? -1 : a.cree < b.cree ? 1 : 0;
    });
}

export function filtre(articles: Article[], motCle: string): Article[] {
    const mot = motCle.trim().toLowerCase();
    if (mot === '') return articles;
    return articles.filter((a) => a.titre.toLowerCase().includes(mot));
}
