import * as articleloader from "./module/articleloader";
import * as ui from "./module/ui";
import * as categorieloader from "./module/categorieloader";
import * as types from "./module/types";

// https://esbuild.github.io/api/#live-reload
// cette ligne sert à avoir un live reload pendant le dev
(new EventSource("/esbuild"))?.addEventListener("change", () => location.reload());

document.addEventListener("DOMContentLoaded", ()=>{
    let tousArticles: Article [] = [];
    articleloader.loadArticles().then((articles: types.Article[]) =>{
        tousArticles = articles;
         ui.displayArticle(articles);
    });

    categorieloader.loadCategories().then((categories: types.Categorie[]) => ui.displayCategories(categories));

    const recherche = document.getElementById("recherche") as HTMLInputElement;
    recherche.addEventListener("input", ()=>{
        const titre = recherche.value.toLowerCase();
        const filtres = tousArticles.filter((a) =>
            a.titre.toLowerCase().includes(titre)
        );
        displayArticle(filtres)
    });
});

tri();

// mis ça ici le temps de le faire
// TODO: il faut que ça soit lancé après que les 2 autres au dessus soient résolus
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
