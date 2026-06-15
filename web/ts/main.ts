import { loadArticles } from "./module/articleloader";
import { displayArticle, displayCategories, tri } from "./module/ui";
import { loadCategories } from "./module/categorieloader";
import { Article, Categorie } from "./module/types";

// https://esbuild.github.io/api/#live-reload
// cette ligne sert à avoir un live reload pendant le dev
(new EventSource("/esbuild"))?.addEventListener("change", () => location.reload());

loadArticles().then((articles: Article[]) => displayArticle(articles));
loadCategories().then((categories: Categorie[]) => displayCategories(categories));
tri();

// mis ça ici le temps de le faire
for (const auteurName of document.querySelectorAll(".auteurName")) {
  if (auteurName instanceof HTMLElement) {
    auteurName.addEventListener("click", e => {
      const url = `/api/auteurs/${auteurName.dataset.id}/articles`;
      const auteur = fetch(url)
        //
        .then(r => r.json())
        .then(r => {
          const auteurDetails = document.createElement("p");
          auteurName.parentElement?.parentElement?.appendChild(auteurDetails);
        })
        .catch(err => {
          console.error("Erreur : " + err);
        });
    });
  }
}
