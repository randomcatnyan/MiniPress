import * as articleloader from "./module/articleloader";
import * as ui from "./module/ui";
import * as categorieloader from "./module/categorieloader";
import * as types from "./module/types";
import * as config from "./module/config";

// https://esbuild.github.io/api/#live-reload
// cette ligne sert à avoir un live reload pendant le dev
(new EventSource("/esbuild"))?.addEventListener("change", () => location.reload());

let allArticles: types.Article[] = [];

let articlesLoad = articleloader.loadArticles()
  .then((articles: types.Article[]) => {
    allArticles = articles;
    ui.displayArticle(articles);
  });

let categoriesLoad = categorieloader.loadCategories()
  .then((categories: types.Categorie[]) => ui.displayCategories(categories));

const recherche = document.getElementById("recherche") as HTMLInputElement;
recherche.addEventListener("input", () => {
  const titre = recherche.value.toLowerCase();
  const filtres = allArticles.filter((a) =>
    a.titre.toLowerCase().includes(titre)
  );
  ui.displayArticle(filtres)
});

ui.tri();
ui.filtre();

Promise.allSettled([categoriesLoad, articlesLoad]).then(() => {
  for (const auteurName of document.querySelectorAll(".auteurName")) {
    if (auteurName instanceof HTMLElement) {
      auteurName.addEventListener("click", e => {
        const url = `${config.API_URL}/auteurs/${auteurName.dataset.id}/articles`;
        fetch(url)
          .then(r => r.json())
          .then(r => {
            const auteurDetails = document.createElement("p").appendChild(document.createTextNode(r.toString()));
            auteurName.parentElement?.parentElement?.appendChild(auteurDetails);
          })
          .catch(err => {
            console.error("Erreur : " + err);
          });
      });
    }
  }
}
)