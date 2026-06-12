import { loadArticles } from "./module/articleloader";
import { displayArticle, displayCategories } from "./module/ui";
import { loadCategories } from "./module/categorieloader";

// https://esbuild.github.io/api/#live-reload
// cette ligne sert à avoir un live reload pendant le dev
// new EventSource("/esbuild").addEventListener("change", () => location.reload());

// console.log("ss");

let p = document.querySelector("p");
if (p) p.textContent = "aadsdda";

document.addEventListener("DOMContentLoaded", async () => {
  loadArticles().then((articles: any) => displayArticle(articles));
  loadCategories().then((categories: any) => displayCategories(categories))
});
