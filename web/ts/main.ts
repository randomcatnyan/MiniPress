import { loadArticles } from "./module/articleloader";
import { displayArticle, displayCategories } from "./module/ui";
import { loadCategories } from "./module/categorieloader";
import { Article, Categorie } from "./module/types";

// https://esbuild.github.io/api/#live-reload
// cette ligne sert à avoir un live reload pendant le dev
const hotReload = new EventSource("/esbuild") ?? null;
hotReload?.addEventListener("change", () => location.reload());


// console.log("ss");

let p = document.querySelector("p");
if (p) p.textContent = "aadsdda";

document.addEventListener("DOMContentLoaded", async () => {
  loadArticles().then((articles: any) => displayArticle(articles));
  loadCategories().then((categories: any) => displayCategories(categories))
});

loadArticles().then((articles: Article[]) => displayArticle(articles));
loadCategories().then((categories: Categorie[]) => displayCategories(categories));

