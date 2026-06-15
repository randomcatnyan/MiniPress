import { loadArticles } from "./module/articleloader";
import { displayArticle, displayCategories } from "./module/ui";
import { loadCategories } from "./module/categorieloader";
import { Article, Categorie } from "./module/types";

// https://esbuild.github.io/api/#live-reload
// cette ligne sert à avoir un live reload pendant le dev
const hotReload = new EventSource("/esbuild") ?? null;
hotReload?.addEventListener("change", () => location.reload());

document.addEventListener("DOMContentLoaded", ()=>{
    let tousArticles: Article [] = [];
    loadArticles().then((articles: Article[]) =>{
        tousArticles = articles;
        displayArticle(articles);
    });

    loadCategories().then((categories: Categorie[]) => displayCategories(categories));

    const recherche = document.getElementById("recherche") as HTMLInputElement;
    recherche.addEventListener("input", ()=>{
        const titre = recherche.value.toLowerCase();
        const filtres = tousArticles.filter((a) =>
            a.titre.toLowerCase().includes(titre)
        );
        displayArticle(filtres)
    });
});
