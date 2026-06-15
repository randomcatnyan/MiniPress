import * as articleloader from "./module/articleloader";
import * as ui from "./module/ui";
import * as categorieloader from "./module/categorieloader";
import * as types from "./module/types";
import * as config from "./module/config";

// https://esbuild.github.io/api/#live-reload
// cette ligne sert à avoir un live reload pendant le dev
(new EventSource("/esbuild"))?.addEventListener("change", () => location.reload());

let allArticles: types.Article[] = [];

<<<<<<< HEAD
=======
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
  for (const auteurName of document.querySelectorAll(".auteurName") as unknown as HTMLElement[]) {
    auteurName.addEventListener("click", () => {
      const url = `${config.API_URL}/auteurs/${auteurName.dataset.id}/articles`;
      fetch(url)
        .then(r => r.json())
        .then(r => {
          const auteurDetails = document.createElement("ul")
          Object.values(r.articles).forEach(article => {
            if (isArticle(article)) {
              let li = document.createElement("li");
              li.textContent = `${article.titre} (rajouté le ${article.cree})`;
              auteurDetails.appendChild(li);
            }
          });
          auteurName.parentElement?.parentElement?.appendChild(auteurDetails);
        })
        .catch(err => {
          console.error("Erreur : " + err);
        });
    });
  }
}
)

// https://stackoverflow.com/questions/71624824/what-does-the-typescript-asserts-operator-do
// https://stackoverflow.com/questions/14425568/interface-type-check-with-typescript
function isArticle(article: any): article is types.Article {
  return true; // TODO
}
>>>>>>> 2540470035b2e56b63be305150cdafd102b43d1c
