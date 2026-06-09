-- création de la base de données
create database if not exists minipress char set utf8mb4 collate utf8mb4_unicode_ci;
use minipress;


create table utilisateurs (
    id int auto_increment primary key,
    nom varchar(100) not null,
    email varchar(150) not null unique,
    mdp varchar(255) not null,
    created_at timestamp default current_timestamp,
    updated_at timestamp default current_timestamp on update current_timestamp
) engine=innodb;

create table categories (
    id int auto_increment primary key,
    titre varchar(100) not null,
    description text,
    created_at timestamp default current_timestamp,
    updated_at timestamp default current_timestamp on update current_timestamp
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
    created_at timestamp default current_timestamp,
    updated_at timestamp default current_timestamp on update current_timestamp,
    constraint fk_article_categorie foreign key (categorie_id) references categories(id) on delete set null,
    constraint fk_article_auteur foreign key (auteur_id) references utilisateurs(id) on delete set null
) engine=innodb;