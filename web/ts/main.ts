import { loadArticles } from "./module/articleloader";
import { displayArticle, displayCategories, tri, filtre } from "./module/ui";
import { loadCategories } from "./module/categorieloader";
import { Article, Categorie } from "./module/types";

document.addEventListener("DOMContentLoaded", async () => {
    loadArticles().then((articles: Article[]) => displayArticle(articles));
    loadCategories().then((categories: Categorie[]) => displayCategories(categories));
    
    tri();
    filtre();
});

