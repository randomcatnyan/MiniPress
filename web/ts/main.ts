import { loadArticles } from "./module/articleloader";
import { displayArticle, displayCategories } from "./module/ui";
import { tri, filtre } from "./module/articles";
import { loadCategories } from "./module/categorieloader";
import { Article, Categorie } from "./module/types";

let tousArticles: Article[] = [];
loadArticles()
    .then((articles: Article[]) => {
        tousArticles = articles;
        displayArticle(articles);
    })
    .catch((err) => console.error("Erreur chargement articles :", err.message));


loadCategories().then((categories: Categorie[]) => displayCategories(categories)).catch((err) => console.error("Erreur chargement articles :", err.message));


    const selectTri = document.getElementById("tri-date") as HTMLSelectElement;
    selectTri.addEventListener("change", () => {
        const ordre = selectTri.value === "asc" ? "asc" : "desc";
        displayArticle(tri(tousArticles, ordre));
    });

    const recherche = document.getElementById("recherche") as HTMLInputElement;
    recherche.addEventListener("input", () => {
        displayArticle(filtre(tousArticles, recherche.value));
    });
  

