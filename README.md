# ChessTournament
Gestion de tournois de jeu d'échecs

~ Category
    Age minimum 4 ans.
    Age maximum 127 ans.
    Categorie acceptée : "junior", "senior", "veteran".
    /!\ - Deux catégories ne peuvent pas avoir la même tranche d'age.
    /!\ - une catégorie ne peut être enregistré qu'une fois et la mise a jour ne peut se faire que sur sa tranche d'age.

~ Gender
    Genre accepté : "homme", "femme", "autre".
    /!\ - Un genre ne peut être entré qu'une fois.

~ Role 
    Role accepté : "checkmate", "player", "user".
    /!\ - Un role ne peut être entré qu'une fois.

~ Status 
    Status accepté : "waiting", "ongoing", "finished", "canceled".
    /!\ - Un role ne peut être entré qu'une fois.

~ Place 
    Place accepté : nom chaine entre 2 et 100 charactères.
                    adress chaine entre 7 et 500 charactères.
    /!\ - Une place ne peut être entré qu'une fois (specificité = nom + adresse / adresse).

~ Person
    3 Model : Add, Update, full
    Add ajoute les nouvelle personne avec les données suivantes ;
        - pseudo (caractère entre 3 et 100 charac)
        - genre int (0 = "femme", 1 = "homme", 2 = "autre")
        - email (chaine entre 5 et 300 charac)
        - password (chaine entre 8 et 1000 charac)
        - BirthDate (inférieur a 120 ans et supérieur a 10 ans)
        - role int (0 = "checkmate", 1 = "player", 2 = "user")
        - Elo int

    Update met a jour les données du joueur sur base de son Id;
        - Elo
        - NbrPartPlayed
        - NbrPartWin
        - NbrPartLost
        - NbrPartDraw
        - Score

    full récupère toutes les informations du joueur ;
        - IdPerson
        - Pseudo
        - Gender
        - Mail
        - DateOfBirth
        - DateRegist
        - Role
        - Elo
        - NbrPartPlayed
        - NbrPartWin
        - NbrPartLost
        - NbrPartDraw
        - Score