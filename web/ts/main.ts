import { loadArticles } from "./module/articleloader";
import { displayArticle, displayCategories, tri, filtre } from "./module/ui";
import { loadCategories } from "./module/categorieloader";
import { Article, Categorie } from "./module/types";

// https://esbuild.github.io/api/#live-reload
// cette ligne sert à avoir un live reload pendant le dev
(new EventSource("/esbuild"))?.addEventListener("change", () => location.reload());

loadArticles().then((articles: Article[]) => displayArticle(articles));
loadCategories().then((categories: Categorie[]) => displayCategories(categories));
tri();
filtre();

