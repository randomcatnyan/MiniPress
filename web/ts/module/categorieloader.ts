import { API_URL } from './config';
import { Categorie } from './types';

export async function loadCategories(): Promise<Categorie[]> {
    const response = await fetch(`${API_URL}/categories`);
    if (!response.ok) {
        throw new Error(`erreur pour charger: ${response.status}`);
    }
    const data = await response.json();
    return data as Categorie[];
}