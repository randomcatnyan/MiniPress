export interface Article {
    titre: string;
    cree: string;
    auteur: string;
    lien: string;
}

export interface Categorie {
    id:number;
    titre:string;
    description?:string;
}