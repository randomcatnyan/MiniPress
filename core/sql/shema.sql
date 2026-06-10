create table utilisateurs (
    id int auto_increment primary key,
    nom varchar(100) not null,
    email varchar(150) not null unique,
    mdp varchar(255) not null,
    cree timestamp default current_timestamp,
    maj timestamp default current_timestamp on update current_timestamp
) engine=innodb;

create table categories (
    id int auto_increment primary key,
    titre varchar(100) not null,
    description text,
    cree timestamp default current_timestamp,
    maj timestamp default current_timestamp on update current_timestamp
) engine=innodb;

create table articles (
    id int auto_increment primary key,
    titre varchar(255) not null,
    resume text,
    contenu text not null,
    image_url varchar(2048),
    date_publication timestamp default current_timestamp,
    categorie_id int,
    auteur_id int,
    cree timestamp default current_timestamp,
    maj timestamp default current_timestamp on update current_timestamp,
    constraint fk_article_categorie foreign key (categorie_id) references categories(id),
    constraint fk_article_auteur foreign key (auteur_id) references utilisateurs(id) 
) engine=innodb;