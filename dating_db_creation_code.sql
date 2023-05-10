create database dating_db;
use dating_db;

create table Cities(
id_city int auto_increment primary key,
city_name varchar(64) not null unique);

create table Users (
id_user int auto_increment primary key,
phone_number varchar(11) not null,
password varchar(64) not null,
user_name varchar(128) not null,
gender enum("Мужской","Женский") not null,
city int,
birth_date date,
about varchar(512),
height int,
weight int, 
foreign key (city) references Cities(id_city) on update cascade on delete cascade,
-- check(phone_number LIKE '[7][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
check(height >= 135 and height <= 230),
check(weight >= 35 and weight <= 250));

create table ProfilePhotos (
id_photo int auto_increment primary key,
file_path varchar(128) not null,
on_avatar bool not null,
id_user int,
foreign key (id_user) references Users(id_user) on update cascade on delete cascade);

create table FavoritesList (
id_owner int,
id_favorite int,
primary key(id_owner, id_favorite),
foreign key (id_owner) references Users(id_user) on update cascade on delete cascade,
foreign key (id_favorite) references Users(id_user) on update cascade on delete cascade);

create table Sympathies(
id_sympathy int auto_increment primary key,
id_sender int,
id_receiver int,
is_received bool not null,
foreign key (id_sender) references Users(id_user) on update cascade on delete cascade,
foreign key (id_receiver) references Users(id_user) on update cascade on delete cascade);

create table Dialogs(
id_dialog int auto_increment primary key,
first_person int,
second_person int,
creation_time timestamp DEFAULT CURRENT_TIMESTAMP,
foreign key (first_person) references Users(id_user) on update cascade on delete cascade,
foreign key (second_person) references Users(id_user) on update cascade on delete cascade);

create table Messages(
id_message int auto_increment primary key,
id_dialog int,
id_sender int,
text_message varchar(1024),
sending_time timestamp DEFAULT CURRENT_TIMESTAMP,
foreign key (id_sender) references Users(id_user) on update cascade on delete cascade,
foreign key (id_dialog) references Dialogs(id_dialog) on update cascade on delete cascade);

create table WatchedProfiles(
id_viewing int,
id_viewed int,
watched_time timestamp DEFAULT CURRENT_TIMESTAMP,
primary key (id_viewing, id_viewed),
foreign key (id_viewing) references Users(id_user) on update cascade on delete cascade,
foreign key (id_viewed) references Users(id_user) on update cascade on delete cascade);

insert into Cities values
(0,"Калуга"),
(0,"Москва"),
(0,"Обнинск"),
(0,"Тула"),
(0,"Воронеж"),
(0,"Санкт-Петербург"),
(0,"Сочи");

insert into Users values
(0, "79051236545", "03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4", "Александр", "Мужской", 1, "2000-01-02", "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", 180, 65),
(0, "79673457475", "03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4", "София", "Женский", 1, "2001-05-02", "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", 160, 45),
(0, "79017834839", "03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4", "Анна", "Женский", 2, "1997-04-12", "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", 155, 43),
(0, "79079723473", "03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4", "Максим", "Мужской", 1, "2001-04-15", "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", 176, 75),
(0, "79803672378", "03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4", "Мария", "Женский", 1, "2002-10-09", "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", 165, 55),
(0, "79564784784", "03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4", "Марк", "Мужской", 5, "1999-08-18", "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", 188, 60),
(0, "79051234786", "03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4", "Алиса", "Женский", 3, "2003-11-02", "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", 150, 65),
(0, "79097673477", "03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4", "Ева", "Женский", 6, "1999-06-25", "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", 181, 53),
(0, "79025894589", "03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4", "Иван", "Мужской", 2, "2000-08-29", "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", 176, 65),
(0, "79764783489", "03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4", "Виктория", "Женский",6, "2003-04-14", "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", 160, 61);

insert into Sympathies values
(0,1,2,0),
(0,2,1,0),
(0,5,9,0),
(0,3,6,0),
(0,9,3,0);


insert into  FavoritesList values
(1,2),
(2,3),
(3,1),
(4,2),
(2,9);

insert into Dialogs (first_person, second_person) values
(1,2),
(1,3),
(3,1);

insert into ProfilePhotos(file_path, on_avatar, id_user) values 
("/photos/7f847f25c2c2a1f6cb40391763f858f5.jpg", 1, 1),
("/photos/b6c1e43d-8f31-4287-9dfc-5b729e125333.jpg", 1, 4),
("/photos/e544b817-7f3b-4e21-90ea-c6774547bf85.jpg", 1, 6),
("/photos/ed0cc528e8c9fa73e87d3374e45990c4.jpg", 1, 9);

insert into Messages (id_dialog, id_sender, text_message) values
(1,1,"Lorem ipsum dolor sit amet, consectetur"),
(1,1,"Nullam porta mattis risus, id ultrices turpis."),
(1,2,"Vestibulum fringilla, magna "),
(1,1,"nec eleifend tincidunt, libero est tincidunt neque"),
(1,2,"in tincidunt nulla tortor eget metus"),
(2,1,"Vestibulum lacinia purus est, id cursus ligula interdumr"),
(2,3,"Maecenas consequat lorem velit, eget luctus ex feugiat quis"),
(3,1,"augue vel odio facilisis ultrices"),
(3,3," faucibus libero quis, vulputate lacus");

DELIMITER &&
create procedure UpdateWatchedList(IN id_viewing int)
	begin
		delete from watchedprofiles
        where TIME_TO_SEC(TIMEDIFF(current_timestamp, wathced_time)) > 7200;
	end &&
    
-- drop procedure UpdateWatchedList
    
-- call UpdateWatchedList(1)


-- select * from Users,watchedprofiles
-- where users.id_user

-- select * from users,watchedprofiles
-- where users.id_user = 2 and watchedprofiles

-- select id_viewed from watchedprofiles
-- where id_viewing = 2





