--Создание таблиц Artists, Albums, Songs, Users, Playlists, PlaylistSongs, Favorites

CREATE TABLE IF NOT EXISTS Artists
(
    ID   INTEGER PRIMARY KEY,
    Name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS Albums
(
    ID          INTEGER PRIMARY KEY,
    Title       TEXT NOT NULL,
    ReleaseDate DATE,
    ArtistID    INTEGER,
    FOREIGN KEY (ArtistID) REFERENCES Artists (ID)
);
CREATE TABLE IF NOT EXISTS Songs
(
    ID       INTEGER PRIMARY KEY,
    Title    TEXT NOT NULL,
    AlbumID  INTEGER,
    ArtistID INTEGER,
    Duration INTEGER,
    FOREIGN KEY (AlbumID) REFERENCES Albums (ID),
    FOREIGN KEY (ArtistID) REFERENCES Artists (ID)
);
CREATE TABLE IF NOT EXISTS Users
(
    ID       INTEGER PRIMARY KEY,
    Username TEXT NOT NULL,
    Password TEXT NOT NULL,
    Email    TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS Playlists
(
    ID     INTEGER PRIMARY KEY,
    Name   TEXT NOT NULL,
    UserID INTEGER,
    FOREIGN KEY (UserID) REFERENCES Users (ID)
);

CREATE TABLE IF NOT EXISTS PlaylistSongs
(
    PlaylistID INTEGER,
    SongID     INTEGER,
    PRIMARY KEY (PlaylistID, SongID),
    FOREIGN KEY (PlaylistID) REFERENCES Playlists (ID),
    FOREIGN KEY (SongID) REFERENCES Songs (ID)
);

CREATE TABLE IF NOT EXISTS Favorites
(
    UserID  INTEGER,
    SongID  INTEGER,
    AlbumID INTEGER,
    PRIMARY KEY (UserID, SongID, AlbumID),
    FOREIGN KEY (UserID) REFERENCES Users (ID),
    FOREIGN KEY (SongID) REFERENCES Songs (ID),
    FOREIGN KEY (AlbumID) REFERENCES Albums (ID)
);

--Заполнение тестовыми данными таблиц Artists, Albums, Songs, Users, Playlists, PlaylistSongs, Favorites

INSERT INTO Artists (ID, Name)
VALUES ('1', 'John Doe'),
       ('2', 'Doe John'),
       ('3', 'Jane Doe'),
       ('4', 'Alice Johnson'),
       ('5', 'Bob Smith');

INSERT INTO Albums (ID, Title, ReleaseDate, ArtistID)
VALUES ('1', 'Doe1', '20.12.2013', '1'),
       ('2', 'Doe2', '03.02.2024', '2'),
       ('3', 'Doe3', '28.04.1999', '3'),
       ('4', 'Doe4', '31.11.1965', '4'),
       ('5', 'Doe5', '01.01.2001', '5');

INSERT INTO Songs (ID, Title, AlbumID, ArtistID, Duration)
VALUES ('1', 'DoeSong1', '1', '1', '03:11'),
       ('2', 'DoeSong2', '2', '2', '03:21'),
       ('3', 'DoeSong3', '3', '3', '02:44'),
       ('4', 'DoeSong4', '4', '4', '01:22'),
       ('5', 'DoeSong5', '5', '5', '02:55');

INSERT INTO Users (ID, Username, Password, Email)
VALUES ('1', 'JoeDoe111', '123-456-7890', 'john.doe111@example.com'),
       ('2', 'JoeDoe222', '123-456-8970', 'john.doe222@example.com'),
       ('3', 'JoeDoe333', '123-456-2345', 'john.doe333@example.com'),
       ('4', 'JoeDoe444', '123-456-5678', 'john.doe444@example.com'),
       ('5', 'JoeDoe555', '123-456-2456', 'john.doe555@example.com');

INSERT INTO Playlists (ID, Name, UserID)
VALUES ('1', 'PLaylist01', '1'),
       ('2', 'PLaylist02', '2'),
       ('3', 'PLaylist03', '3'),
       ('4', 'PLaylist04', '4'),
       ('5', 'PLaylist05', '5');

INSERT INTO PlaylistSongs (PLAYLISTID, SONGID)
VALUES ('1', '1'),
       ('2', '2'),
       ('3', '3'),
       ('4', '4'),
       ('5', '5');

-- Создание таблицы Subscriptions и реализация функционала подписок на исполнителей

CREATE TABLE IF NOT EXISTS Subscriptions
(
    UserID   INTEGER,
    ArtistID INTEGER,
    PRIMARY KEY (UserID, ArtistID),
    FOREIGN KEY (UserID) REFERENCES Users (ID),
    FOREIGN KEY (ArtistID) REFERENCES Artists (ID)
);

-- SQL-запрос для добавления подписки пользователя на исполнителя
INSERT INTO Subscriptions (UserID, ArtistID)
VALUES (1, 1);

-- SQL-запрос для удаления подписки пользователя на исполнителя
DELETE
FROM Subscriptions
WHERE UserID = 1
  AND ArtistID = 1;

-- SQL-запрос для получения списка подписок конкретного пользователя
SELECT Artists.Name
FROM Subscriptions
         JOIN Artists ON Subscriptions.ArtistID = Artists.ID
WHERE Subscriptions.UserID = 1;


-- Создание таблицы SongRecommendations и реализация функционала рекомендации песен
CREATE TABLE IF NOT EXISTS SongRecommendations
(
    UserID INTEGER,
    SongID INTEGER,
    PRIMARY KEY (UserID, SongID),
    FOREIGN KEY (UserID) REFERENCES Users (ID),
    FOREIGN KEY (SongID) REFERENCES Songs (ID)
);

-- SQL-запрос для добавления рекомендации песни для пользователя
INSERT INTO SongRecommendations (UserID, SongID)
VALUES (1, 1);

-- SQL-запрос для получения списка рекомендованных песен для конкретного пользователя
SELECT Songs.Title, Songs.Duration
FROM SongRecommendations
         JOIN Songs ON SongRecommendations.SongID = Songs.ID
WHERE SongRecommendations.UserID = 1;

-- Создание временной таблицы с полем Rating
CREATE TABLE TempSongs AS
SELECT *, 0 AS Rating
FROM Songs;

-- Удаление текущей таблицы Songs
DROP TABLE Songs;

-- Переименование временной таблицы в Songs
ALTER TABLE TempSongs
    RENAME TO Songs;

-- Создание таблицы SongReviews для хранения оценок песен пользователями
CREATE TABLE IF NOT EXISTS SongReviews
(
    UserID INTEGER,
    SongID INTEGER,
    Rating FLOAT,
    PRIMARY KEY (UserID, SongID),
    FOREIGN KEY (UserID) REFERENCES Users (ID),
    FOREIGN KEY (SongID) REFERENCES Songs (ID)
);

-- SQL-запрос для добавления оценки песни пользователем
INSERT INTO SongReviews (UserID, SongID, Rating)
VALUES (1, 1, 4.5);

-- SQL-запрос для вычисления среднего рейтинга песни и обновления поля Rating
UPDATE Songs
SET Rating = (SELECT AVG(Rating) FROM SongReviews WHERE SongID = 1)
WHERE ID = 1;

