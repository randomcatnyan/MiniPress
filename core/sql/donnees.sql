USE minipress;

INSERT INTO utilisateurs (nom, email, mdp, role) VALUES
('Alice Dupont',    'alice.dupont@email.com',    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin'),
('Bob Martin',      'bob.martin@email.com',      '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('Claire Moreau',   'claire.moreau@email.com',   '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('David Bernard',   'david.bernard@email.com',   '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('Emma Leroy',      'emma.leroy@email.com',      '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('François Petit',  'francois.petit@email.com',  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('Gaëlle Roux',     'gaelle.roux@email.com',     '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('Hugo Fournier',   'hugo.fournier@email.com',   '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user');


INSERT INTO categories (titre, description) VALUES
('Technologie',    'Actualités et tendances du monde de la tech, intelligence artificielle, gadgets et innovations.'),
('Science',        'Découvertes scientifiques, recherche, espace et environnement.'),
('Culture',        'Arts, cinéma, musique, littérature et événements culturels.'),
('Sport',          'Résultats, analyses et actualités du monde sportif.'),
('Économie',       'Marchés financiers, entreprises, start-ups et tendances économiques.'),
('Santé',          'Bien-être, médecine, nutrition et conseils santé au quotidien.'),
('Voyage',         'Destinations, conseils de voyage, bons plans et récits d''aventures.'),
('Gastronomie',    'Recettes, restaurants, tendances culinaires et critiques gastronomiques.');

INSERT INTO articles (titre, resume, contenu, image_url, categorie_id, auteur_id) VALUES
('L''essor de l''intelligence artificielle en 2026',
 'Comment l''IA transforme notre quotidien et les entreprises.',
 'L''intelligence artificielle connaît une croissance exponentielle en 2026. Des modèles de langage toujours plus performants aux assistants autonomes, l''IA s''intègre désormais dans tous les secteurs d''activité. Les entreprises investissent massivement dans l''automatisation, tandis que les questions éthiques restent au cœur des débats. Cet article explore les avancées majeures de l''année et leurs implications pour la société.',
 'https://images.unsplash.com/photo-1677442135136-760c93c1f236',
 1, 1),

('Les smartphones pliables conquièrent le marché',
 'Analyse de la nouvelle génération de téléphones à écran flexible.',
 'Après des débuts timides, les smartphones pliables représentent désormais 25% des ventes premium. Samsung, Google et Apple proposent chacun leur vision de l''écran flexible. Les prix ont chuté, rendant cette technologie accessible au grand public. Nous avons testé les derniers modèles pour vous proposer un comparatif complet.',
 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9',
 1, 2),

('Découverte d''eau liquide sur Europe, lune de Jupiter',
 'La sonde Europa Clipper confirme la présence d''un océan sous-glaciaire.',
 'La NASA a annoncé une découverte majeure : les données de la sonde Europa Clipper confirment la présence d''un vaste océan d''eau liquide sous la croûte glacée d''Europe. Cette découverte relance le débat sur la possibilité de vie extraterrestre dans notre système solaire. Les scientifiques prévoient déjà de nouvelles missions pour explorer cet environnement unique.',
 'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa',
 2, 3),

('La fusion nucléaire franchit un cap historique',
 'Un réacteur expérimental produit plus d''énergie qu''il n''en consomme pendant 10 minutes.',
 'Le réacteur ITER a réussi à maintenir une réaction de fusion nucléaire nette positive pendant dix minutes consécutives, un record absolu. Cette avancée ouvre la voie à une source d''énergie propre et quasi illimitée. Les chercheurs estiment qu''un prototype commercial pourrait voir le jour d''ici 2035.',
 'https://images.unsplash.com/photo-1635070041078-e363dbe005cb',
 2, 4),

('Festival de Cannes 2026 : les films à ne pas manquer',
 'Notre sélection des œuvres les plus attendues de la compétition officielle.',
 'Le 79e Festival de Cannes promet une édition exceptionnelle avec des réalisateurs de renom et de nouveaux talents. Notre critique cinéma a analysé les bandes-annonces et les premières projections pour vous proposer un guide complet. De la Palme d''Or aux sections parallèles, voici les films qui feront parler d''eux cet été.',
 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba',
 3, 5),

('Le renouveau de la bande dessinée francophone',
 'Comment les auteurs franco-belges réinventent le 9e art.',
 'La bande dessinée francophone vit un âge d''or créatif. De nouveaux formats, des thématiques audacieuses et une ouverture internationale attirent un public toujours plus large. Nous avons rencontré cinq auteurs qui repoussent les limites du genre et explorent des territoires narratifs inédits.',
 'https://images.unsplash.com/photo-1601645191163-3fc0d5d64e35',
 3, 6),

('Coupe du Monde 2026 : les favoris et les surprises',
 'Analyse tactique des équipes qualifiées pour le Mondial nord-américain.',
 'La Coupe du Monde 2026, organisée conjointement par les États-Unis, le Canada et le Mexique, s''annonce historique avec 48 équipes qualifiées. Notre analyste sportif décrypte les forces en présence, les tactiques innovantes et les joueurs à surveiller. Le Brésil, la France et l''Argentine partent favoris, mais des outsiders pourraient créer la surprise.',
 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d',
 4, 7),

('Le Tour de France 2026 : un parcours de montagne inédit',
 'Présentation des étapes clés de la Grande Boucle.',
 'Le parcours du Tour de France 2026 fait la part belle aux cols alpins et pyrénéens avec pas moins de huit arrivées en altitude. Les grimpeurs seront à la fête sur ce tracé exigeant qui promet des batailles épiques. Tadej Pogačar tentera de décrocher un quatrième titre consécutif face à une concurrence relevée.',
 'https://images.unsplash.com/photo-1517649763962-0c623066013b',
 4, 8),

('Les cryptomonnaies face à la régulation européenne',
 'Le règlement MiCA entre en vigueur : quelles conséquences pour les investisseurs ?',
 'L''Union européenne applique désormais pleinement le règlement MiCA (Markets in Crypto-Assets). Les plateformes d''échange doivent se conformer à des exigences strictes de transparence et de protection des investisseurs. Cet article analyse les impacts sur le marché, les opportunités pour les acteurs régulés et les risques pour les projets non conformes.',
 'https://images.unsplash.com/photo-1639762681485-074b7f938ba0',
 5, 1),

('Télétravail : les entreprises françaises entre retour au bureau et flexibilité',
 'Enquête sur les nouvelles organisations du travail en 2026.',
 'Trois ans après la généralisation du télétravail, les entreprises françaises adoptent des modèles hybrides variés. Certaines imposent un retour au bureau à temps plein, d''autres misent sur la flexibilité totale. Notre enquête auprès de 500 entreprises révèle les tendances, les avantages et les défis de chaque approche.',
 'https://images.unsplash.com/photo-1522071820081-009f0129c71c',
 5, 2),

('Les bienfaits insoupçonnés de la marche quotidienne',
 '30 minutes de marche par jour : des effets prouvés sur le corps et l''esprit.',
 'Une méta-analyse portant sur 50 000 participants confirme les bienfaits exceptionnels de la marche quotidienne. Réduction des risques cardiovasculaires, amélioration de la santé mentale, renforcement du système immunitaire : les effets sont multiples et significatifs. Nous détaillons les résultats et proposons un programme progressif adapté à tous les âges.',
 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8',
 6, 3),

('Nutrition : le retour en grâce des légumineuses',
 'Pourquoi les lentilles, pois chiches et haricots sont les aliments de demain.',
 'Riches en protéines, en fibres et en minéraux, les légumineuses s''imposent comme un pilier de l''alimentation durable. Les chefs étoilés les mettent à l''honneur, l''industrie agroalimentaire développe de nouveaux produits à base de légumineuses, et les nutritionnistes les recommandent pour une alimentation équilibrée. Tour d''horizon d''un phénomène culinaire et nutritionnel.',
 'https://images.unsplash.com/photo-1515543904413-63b3b7a4e073',
 6, 4),

('Les Açores : le secret le mieux gardé de l''Atlantique',
 'Guide complet pour découvrir cet archipel portugais préservé du tourisme de masse.',
 'Situées en plein Atlantique, les Açores offrent des paysages à couper le souffle : volcans, lacs de cratère, forêts luxuriantes et côtes sauvages. Encore épargnées par le tourisme de masse, ces îles portugaises séduisent les voyageurs en quête d''authenticité. Notre guide pratique couvre les neuf îles, avec les meilleures randonnées, restaurants et hébergements.',
 'https://images.unsplash.com/photo-1555881400-74d7acaacd8b',
 7, 5),

('Japon hors des sentiers battus : 5 régions méconnues',
 'Au-delà de Tokyo et Kyoto, découvrez un Japon authentique et surprenant.',
 'Le Japon ne se résume pas à Tokyo et Kyoto. De la péninsule de Noto aux montagnes de Shikoku, en passant par les villages historiques de Tohoku, le pays regorge de trésors cachés. Nous avons exploré cinq régions méconnues pour vous offrir un voyage au cœur du Japon traditionnel, loin de la foule.',
 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e',
 7, 6),

('La pâtisserie française se réinvente',
 'Moins de sucre, plus de créativité : les nouvelles tendances sucrées.',
 'La pâtisserie française évolue sous l''impulsion d''une nouvelle génération de chefs. Réduction du sucre, utilisation de farines alternatives, intégration de légumes et d''épices : les créations sont plus audacieuses et plus saines que jamais. Nous avons visité cinq pâtisseries parisiennes qui incarnent cette révolution gustative.',
 'https://images.unsplash.com/photo-1488477181946-6428a0291777',
 8, 7),

('Vins naturels : guide pour les débutants',
 'Comprendre et apprécier les vins sans intrants chimiques.',
 'Les vins naturels séduisent de plus en plus d''amateurs, mais leur diversité peut dérouter les néophytes. Qu''est-ce qu''un vin naturel exactement ? Comment le choisir ? Avec quels plats l''accorder ? Notre sommelier répond à toutes vos questions et vous propose une sélection de dix bouteilles accessibles pour découvrir cet univers passionnant.',
 'https://images.unsplash.com/photo-1474722883778-792e7990302f',
 8, 8);
