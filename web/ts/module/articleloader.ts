import { API_URL } from './config.ts';
import { Article } from './types.ts';


export async function loadArticles(): Promise<Article[]> {
    const response = await fetch(`${API_URL}/articles`);
    if (!response.ok) {
        throw new Error(`Erreur ${response.status}`);
    }
    const data = await response.json();
    return data as Article[];
}
