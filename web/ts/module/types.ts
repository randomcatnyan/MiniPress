export interface Article {
    titre: string;
    cree: string;
    auteur: {
        nom: string;
        id: number;
    }
    lien: string;
}

export interface Categorie {
    id:number;
    titre:string;
    description?:string;
}

export interface ArticleComplet{
    id: number;
    titre: string;
    resume: string;
    contenu: string;
    cree: string;
    auteur: {
        nom: string;
        id: number;
    }
}