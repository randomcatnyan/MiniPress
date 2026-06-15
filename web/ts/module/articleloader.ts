import { API_URL } from './config';
import { Article } from './types';

export async function loadArticles(): Promise<Article[]> {
    const response = await fetch(`${API_URL}/articles`);
    if (!response.ok) {
        throw new Error(`Erreur ${response.status}`);
    }
    const data = await response.json();
    return data;
}

export async function loadArticleComplet(lien: string): Promise<any>{
    const base = API_URL.replace('/api', '');   
    const reponse = await fetch(`${base}${lien}`);
    if (!reponse.ok) {
        throw new Error(`Erreur ${reponse.status}`);
    }
    const data = await reponse.json();
    return data;
}

export async function loadArticlesByCategorie(id: number): Promise<Article[]> {
    const response = await fetch(`${API_URL}/categories/${id}/articles`);
    if (!response.ok) {
        throw new Error(`Erreur ${response.status}`);
    }
    const data = await response.json();
    return data.articles as Article[]; 
}

export async function loadArticlesByAuteur(id: number): Promise<Article[]> {
    const response = await fetch(`${API_URL}/auteurs/${id}/articles`);
    if (!response.ok) {
        throw new Error(`erreur: ${response.status}`);
    }
    const data = await response.json();
    return data.articles ? (data.articles as Article[]) : (data as Article[]);
}