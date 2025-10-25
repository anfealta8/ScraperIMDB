-- Top 5 películas con mayor duración promedio por década

WITH peliculas_decada AS (
    SELECT 
        titulo,
        anio,
        duracion,
        FLOOR(anio / 10) * 10 as decada
    FROM peliculas
    WHERE duracion IS NOT NULL
)
SELECT 
    decada,
    titulo,
    duracion
FROM (
    SELECT 
        decada,
        titulo,
        duracion,
        ROW_NUMBER() OVER (PARTITION BY decada ORDER BY duracion DESC) as ranking
    FROM peliculas_decada
) ranked
WHERE ranking <= 5
ORDER BY decada DESC, duracion DESC;

-- respuesta 
decada, titulo, duracion
2020	Oppenheimer	180
2020	Dune: Part Two	166
2020	Jai Bhim	164
2020	One Battle After Another	161
2020	Hamilton	160
2010	Gangs of Wasseypur	321
2010	Avengers: Endgame	181
2010	The Wolf of Wall Street	180
2010	Interstellar	169
2010	Django Unchained	165
2000	The Best of Youth	374
2000	The Lord of the Rings: The Return of the King	201
2000	The Lord of the Rings: The Two Towers	179
2000	The Lord of the Rings: The Fellowship of the Ring	178
2000	3 Idiots	170
1990	Schindler's List	195
1990	The Green Mile	189
1990	Braveheart	178
1990	Casino	178
1990	Heat	170
1980	Once Upon a Time in America	229
1980	Cinema Paradiso	174
1980	Scarface	170
1980	Amadeus	160
1980	Ran	160
1970	The Godfather Part II	202
1970	Barry Lyndon	185
1970	The Deer Hunter	183
1970	The Godfather	175
1970	Apocalypse Now	147
1960	Lawrence of Arabia	227
1960	Judgment at Nuremberg	179
1960	The Good, the Bad and the Ugly	178
1960	The Sound of Music	174
1960	The Great Escape	172
1950	Ben-Hur	212
1950	Seven Samurai	207
1950	The Bridge on the River Kwai	161
1950	The Wages of Fear	156
1950	Ikiru	143
1940	The Best Years of Our Lives	170
1940	It's a Wonderful Life	130
1940	The Grapes of Wrath	129
1940	The Treasure of the Sierra Madre	126
1940	The Great Dictator	125
1930	Gone with the Wind	238
1930	Mr. Smith Goes to Washington	129
1930	The Wizard of Oz	102
1930	M	99
1930	City Lights	87
1920	Metropolis	153
1920	The Passion of Joan of Arc	114
1920	The Gold Rush	95
1920	The General	78
1920	The Kid	68

-- 2. Desviación estándar de calificaciones por año

SELECT 
    anio,
    ROUND(AVG(calificacion), 2) as promedio_calificacion,
    ROUND(STDDEV(calificacion), 2) as desviacion_estandar,
    COUNT(*) as total_peliculas
FROM peliculas
GROUP BY anio
HAVING COUNT(*) > 1
ORDER BY anio DESC;


-- respuesta

anio, promedio_calificacion, desviacion_estandar, total_peliculas
2025	8.35	0.15	2
2024	8.30	0.08	3
2023	8.50	0.16	3
2021	8.40	0.2	2
2020	8.23	0.05	3
2019	8.28	0.13	6
2018	8.35	0.09	4
2017	8.20	0.14	3
2016	8.22	0.12	5
2015	8.12	0.04	5
2014	8.30	0.25	5
2013	8.15	0.05	4
2012	8.35	0.11	4
2011	8.22	0.16	5
2010	8.34	0.24	5
2009	8.25	0.13	6
2008	8.53	0.42	3
2007	8.20	0.07	4
2006	8.40	0.12	4
2005	8.17	0.05	3
2004	8.14	0.09	7
2003	8.33	0.29	7
2002	8.50	0.25	4
2001	8.42	0.29	5
2000	8.35	0.11	4
1999	8.45	0.26	6
1998	8.30	0.21	5
1997	8.32	0.15	5
1996	8.10	0	2
1995	8.30	0.17	8
1994	8.78	0.29	5
1993	8.43	0.4	3
1992	8.25	0.05	2
1991	8.60	0	2
1989	8.15	0.05	2
1988	8.33	0.18	4
1986	8.20	0.14	3
1985	8.33	0.12	3
1984	8.27	0.12	3
1983	8.30	0	2
1982	8.15	0.05	2
1981	8.40	0	2
1980	8.35	0.23	4
1979	8.45	0.05	2
1976	8.13	0.05	3
1975	8.34	0.26	5
1974	8.55	0.45	2
1973	8.15	0.05	2
1968	8.40	0.1	2
1966	8.45	0.35	2
1965	8.15	0.05	2
1963	8.30	0.1	2
1962	8.40	0.14	3
1961	8.25	0.05	2
1960	8.40	0.1	2
1959	8.20	0.08	3
1957	8.35	0.32	6
1954	8.35	0.21	4
1953	8.10	0	2
1952	8.30	0	2
1950	8.23	0.12	3
1948	8.20	0	2
1946	8.35	0.25	2
1942	8.30	0.2	2
1940	8.25	0.15	2
1939	8.13	0.05	3
1931	8.40	0.1	2


-- 3. Películas con diferencia >20% entre calificación IMDB y Metascore

SELECT 
    titulo,
    anio,
    calificacion,
    metascore,
    ROUND(ABS(calificacion - (metascore/10.0)) / calificacion * 100, 2) as diferencia_porcentual
FROM peliculas
WHERE metascore IS NOT NULL
    AND ABS(calificacion - (metascore/10.0)) / calificacion > 0.2
ORDER BY diferencia_porcentual DESC;

-- respuesta

titulo, anio, calificacion, metascore, diferencia_porcentual
The Intouchables	2011	8.5	57	32.94
Snatch	2000	8.2	55	32.93
Life Is Beautiful	1997	8.6	58	32.56
The Thing	1982	8.2	57	30.49
Star Wars: Episode VI - Return of the Jedi	1983	8.3	58	30.12
The Green Mile	1999	8.6	61	29.07
Joker	2019	8.3	59	28.92
Judgment at Nuremberg	1961	8.3	60	27.71
American History X	1998	8.5	62	27.06
Léon: The Professional	1994	8.5	64	24.71
Se7en	1995	8.6	65	24.42
Fight Club	1999	8.8	67	23.86
The Help	2011	8.1	62	23.46
Tokyo Story	1953	8.1	100	23.46
V for Vendetta	2005	8.1	62	23.46
Shutter Island	2010	8.2	63	23.17
The Prestige	2006	8.5	66	22.35
The Sound of Music	1965	8.1	63	22.22
Pirates of the Caribbean: The Curse of the Black Pearl	2003	8.1	63	22.22
The Sixth Sense	1999	8.2	64	21.95
Vertigo	1958	8.2	100	21.95
Citizen Kane	1941	8.2	100	21.95
Scarface	1983	8.3	65	21.69
Demon Slayer: Kimetsu no Yaiba- The Movie - Infinity Castle	2025	8.5	67	21.18
Gladiator	2000	8.5	67	21.18
The Passion of Joan of Arc	1928	8.1	98	20.99
Rashomon	1950	8.1	98	20.99
Klaus	2019	8.2	65	20.73
Indiana Jones and the Last Crusade	1989	8.2	65	20.73
Lawrence of Arabia	1962	8.3	100	20.48
3 Idiots	2009	8.4	67	20.24

-- 4. Vista para relacionar películas y actores principales

-- Crear la vista
CREATE OR REPLACE VIEW vista_peliculas_actores AS
SELECT 
    p.titulo,
    p.anio,
    p.calificacion,
    a.nombre as actor_principal,
    ROW_NUMBER() OVER (PARTITION BY p.id ORDER BY a.id) as orden_actor
FROM peliculas p
JOIN actores a ON p.id = a.pelicula_id;

-- Consultar actores principales (primeros 3 por película)
SELECT titulo, actor_principal
FROM vista_peliculas_actores
WHERE orden_actor <= 3
ORDER BY titulo, orden_actor;

-- respuesta

titulo, actor_principal
12 Angry Men	Sidney Lumet
12 Angry Men	Reginald Rose
12 Angry Men	Martin Balsam
12 Years a Slave	Steve McQueen
12 Years a Slave	John Ridley
12 Years a Slave	Solomon Northup
12th Fail	Vidhu Vinod Chopra
12th Fail	Vidhu Vinod Chopra
12th Fail	Jaskunwar Kohli
1917	Sam Mendes
1917	Sam Mendes
1917	Krysty Wilson-Cairns
2001: A Space Odyssey	Stanley Kubrick
2001: A Space Odyssey	Stanley Kubrick
2001: A Space Odyssey	Arthur C. Clarke
3 Idiots	Rajkumar Hirani
3 Idiots	Abhijat Joshi
3 Idiots	Rajkumar Hirani
A Beautiful Mind	Ron Howard
A Beautiful Mind	Akiva Goldsman
A Beautiful Mind	Sylvia Nasar
A Clockwork Orange	Stanley Kubrick
A Clockwork Orange	Stanley Kubrick
A Clockwork Orange	Anthony Burgess
A Separation	Asghar Farhadi
A Separation	Asghar Farhadi
A Separation	Payman Maadi
A Silent Voice: The Movie	Naoko Yamada
A Silent Voice: The Movie	Yoshitoki Ôima
A Silent Voice: The Movie	Reiko Yoshida
Alien	Ridley Scott
Alien	Dan O'Bannon
Alien	Ronald Shusett
Aliens	James Cameron
Aliens	James Cameron
Aliens	David Giler
All About Eve	Joseph L. Mankiewicz
All About Eve	Joseph L. Mankiewicz
All About Eve	Mary Orr
Amadeus	Milos Forman
Amadeus	Peter Shaffer
Amadeus	Zdenek Mahler
Amélie	Jean-Pierre Jeunet
Amélie	Guillaume Laurant
Amélie	Jean-Pierre Jeunet
American Beauty	Sam Mendes
American Beauty	Alan Ball
American Beauty	Kevin Spacey
American History X	Tony Kaye
American History X	David McKenna
American History X	Edward Norton
Apocalypse Now	Francis Ford Coppola
Apocalypse Now	John Milius
Apocalypse Now	Francis Ford Coppola
Avengers: Endgame	Anthony Russo
Avengers: Endgame	Joe Russo
Avengers: Endgame	Christopher Markus
Avengers: Infinity War	Anthony Russo
Avengers: Infinity War	Joe Russo
Avengers: Infinity War	Christopher Markus
Back to the Future	Robert Zemeckis
Back to the Future	Robert Zemeckis
Back to the Future	Bob Gale
Barry Lyndon	Stanley Kubrick
Barry Lyndon	Stanley Kubrick
Barry Lyndon	William Makepeace Thackeray
Batman Begins	Christopher Nolan
Batman Begins	Bob Kane
Batman Begins	David S. Goyer
Before Sunrise	Richard Linklater
Before Sunrise	Richard Linklater
Before Sunrise	Kim Krizan
Before Sunset	Richard Linklater
Before Sunset	Richard Linklater
Before Sunset	Julie Delpy
Ben-Hur	William Wyler
Ben-Hur	Lew Wallace
Ben-Hur	Karl Tunberg
Bicycle Thieves	Vittorio De Sica
Bicycle Thieves	Cesare Zavattini
Bicycle Thieves	Luigi Bartolini
Blade Runner	Ridley Scott
Blade Runner	Hampton Fancher
Blade Runner	David Webb Peoples
Braveheart	Mel Gibson
Braveheart	Randall Wallace
Braveheart	James Robinson
Capernaum	Nadine Labaki
Capernaum	Nadine Labaki
Capernaum	Jihad Hojeily
Casablanca	Michael Curtiz
Casablanca	Philip G. Epstein
Casablanca	Julius J. Epstein
Casino	Martin Scorsese
Casino	Nicholas Pileggi
Casino	Martin Scorsese
Catch Me If You Can	Steven Spielberg
Catch Me If You Can	Frank Abagnale Jr.
Catch Me If You Can	Stan Redding
Children of Heaven	Majid Majidi
Children of Heaven	Majid Majidi
Children of Heaven	Reza Naji
Chinatown	Roman Polanski
Chinatown	Robert Towne
Chinatown	Roman Polanski
Cinema Paradiso	Giuseppe Tornatore
Cinema Paradiso	Giuseppe Tornatore
Cinema Paradiso	Vanna Paoli
Citizen Kane	Orson Welles
Citizen Kane	Herman J. Mankiewicz
Citizen Kane	Orson Welles
City Lights	Charles Chaplin
City Lights	Charles Chaplin
City Lights	Harry Carr
City of God	Kátia Lund
City of God	Fernando Meirelles
City of God	Bráulio Mantovani
Coco	Adrian Molina
Coco	Lee Unkrich
Coco	Lee Unkrich
Come and See	Elem Klimov
Come and See	Ales Adamovich
Come and See	Elem Klimov
Dangal	Nitesh Tiwari
Dangal	Piyush Gupta
Dangal	Shreyas Jain
Das Boot	Wolfgang Petersen
Das Boot	Lothar G. Buchheim
Das Boot	Wolfgang Petersen
Dead Poets Society	Peter Weir
Dead Poets Society	Tom Schulman
Dead Poets Society	Robin Williams
Demon Slayer: Kimetsu no Yaiba - The Movie: Mugen Train	Haruo Sotozaki
Demon Slayer: Kimetsu no Yaiba - The Movie: Mugen Train	Koyoharu Gotouge
Demon Slayer: Kimetsu no Yaiba - The Movie: Mugen Train	Natsuki Hanae
Demon Slayer: Kimetsu no Yaiba- The Movie - Infinity Castle	Hikaru Kondô
Demon Slayer: Kimetsu no Yaiba- The Movie - Infinity Castle	Haruo Sotozaki
Demon Slayer: Kimetsu no Yaiba- The Movie - Infinity Castle	Koyoharu Gotouge
Dial M for Murder	Alfred Hitchcock
Dial M for Murder	Frederick Knott
Dial M for Murder	Ray Milland
Die Hard	John McTiernan
Die Hard	Roderick Thorp
Die Hard	Jeb Stuart
Django Unchained	Quentin Tarantino
Django Unchained	Quentin Tarantino
Django Unchained	Jamie Foxx
Double Indemnity	Billy Wilder
Double Indemnity	Billy Wilder
Double Indemnity	Raymond Chandler
Downfall	Oliver Hirschbiegel
Downfall	Bernd Eichinger
Downfall	Joachim Fest
Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb	Stanley Kubrick
Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb	Stanley Kubrick
Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb	Terry Southern
Drishyam	Nishikant Kamat
Drishyam	Jeethu Joseph
Drishyam	Upendra Sidhaye
Dune: Part Two	Denis Villeneuve
Dune: Part Two	Denis Villeneuve
Dune: Part Two	Jon Spaihts
Eternal Sunshine of the Spotless Mind	Michel Gondry
Eternal Sunshine of the Spotless Mind	Charlie Kaufman
Eternal Sunshine of the Spotless Mind	Michel Gondry
Fargo	Joel Coen
Fargo	Ethan Coen
Fargo	Ethan Coen
Fight Club	David Fincher
Fight Club	Chuck Palahniuk
Fight Club	Jim Uhls
Finding Nemo	Andrew Stanton
Finding Nemo	Lee Unkrich
Finding Nemo	Andrew Stanton
For a Few Dollars More	Sergio Leone
For a Few Dollars More	Sergio Leone
For a Few Dollars More	Fulvio Morsella
Ford v Ferrari	James Mangold
Ford v Ferrari	Jez Butterworth
Ford v Ferrari	John-Henry Butterworth
Forrest Gump	Robert Zemeckis
Forrest Gump	Winston Groom
Forrest Gump	Eric Roth
Full Metal Jacket	Stanley Kubrick
Full Metal Jacket	Stanley Kubrick
Full Metal Jacket	Michael Herr
Gangs of Wasseypur	Anurag Kashyap
Gangs of Wasseypur	Akhilesh Jaiswal
Gangs of Wasseypur	Anurag Kashyap
Gladiator	Ridley Scott
Gladiator	David Franzoni
Gladiator	John Logan
Gone Girl	David Fincher
Gone Girl	Gillian Flynn
Gone Girl	Ben Affleck
Gone with the Wind	Victor Fleming
Gone with the Wind	Margaret Mitchell
Gone with the Wind	Sidney Howard
Good Will Hunting	Gus Van Sant
Good Will Hunting	Matt Damon
Good Will Hunting	Ben Affleck
Goodfellas	Martin Scorsese
Goodfellas	Nicholas Pileggi
Goodfellas	Martin Scorsese
Gran Torino	Clint Eastwood
Gran Torino	Nick Schenk
Gran Torino	Dave Johannson
Grave of the Fireflies	Isao Takahata
Grave of the Fireflies	Akiyuki Nosaka
Grave of the Fireflies	Isao Takahata
Green Book	Peter Farrelly
Green Book	Nick Vallelonga
Green Book	Brian Hayes Currie
Hachi: A Dog's Tale	Lasse Hallström
Hachi: A Dog's Tale	Stephen P. Lindsey
Hachi: A Dog's Tale	Kaneto Shindô
Hacksaw Ridge	Mel Gibson
Hacksaw Ridge	Robert Schenkkan
Hacksaw Ridge	Andrew Knight
Hamilton	Thomas Kail
Hamilton	Lin-Manuel Miranda
Hamilton	Ron Chernow
Harakiri	Masaki Kobayashi
Harakiri	Yasuhiko Takiguchi
Harakiri	Shinobu Hashimoto
Harry Potter and the Deathly Hallows: Part 2	David Yates
Harry Potter and the Deathly Hallows: Part 2	Steve Kloves
Harry Potter and the Deathly Hallows: Part 2	J.K. Rowling
Heat	Michael Mann
Heat	Michael Mann
Heat	Al Pacino
High and Low	Akira Kurosawa
High and Low	Hideo Oguni
High and Low	Ryûzô Kikushima
Hotel Rwanda	Terry George
Hotel Rwanda	Keir Pearson
Hotel Rwanda	Terry George
How to Train Your Dragon	Dean DeBlois
How to Train Your Dragon	Chris Sanders
How to Train Your Dragon	William Davies
Howl's Moving Castle	Hayao Miyazaki
Howl's Moving Castle	Hayao Miyazaki
Howl's Moving Castle	Diana Wynne Jones
Ikiru	Akira Kurosawa
Ikiru	Akira Kurosawa
Ikiru	Shinobu Hashimoto
In the Name of the Father	Jim Sheridan
In the Name of the Father	Gerry Conlon
In the Name of the Father	Terry George
Incendies	Denis Villeneuve
Incendies	Wajdi Mouawad
Incendies	Denis Villeneuve
Inception	Christopher Nolan
Inception	Christopher Nolan
Inception	Leonardo DiCaprio
Indiana Jones and the Last Crusade	Steven Spielberg
Indiana Jones and the Last Crusade	Jeffrey Boam
Indiana Jones and the Last Crusade	George Lucas
Inglourious Basterds	Quentin Tarantino
Inglourious Basterds	Quentin Tarantino
Inglourious Basterds	Brad Pitt
Inside Out	Ronnie Del Carmen
Inside Out	Pete Docter
Inside Out	Pete Docter
Interstellar	Christopher Nolan
Interstellar	Jonathan Nolan
Interstellar	Christopher Nolan
It's a Wonderful Life	Frank Capra
It's a Wonderful Life	Frances Goodrich
It's a Wonderful Life	Albert Hackett
Jai Bhim	T.J. Gnanavel
Jai Bhim	T.J. Gnanavel
Jai Bhim	Rajendra Sapre
Jaws	Steven Spielberg
Jaws	Peter Benchley
Jaws	Carl Gottlieb
Joker	Todd Phillips
Joker	Todd Phillips
Joker	Scott Silver
Judgment at Nuremberg	Stanley Kramer
Judgment at Nuremberg	Abby Mann
Judgment at Nuremberg	Montgomery Clift
Jurassic Park	Steven Spielberg
Jurassic Park	Michael Crichton
Jurassic Park	David Koepp
Kill Bill: Vol. 1	Quentin Tarantino
Kill Bill: Vol. 1	Quentin Tarantino
Kill Bill: Vol. 1	Uma Thurman
Klaus	Carlos Martínez López
Klaus	Sergio Pablos
Klaus	Sergio Pablos
L.A. Confidential	Curtis Hanson
L.A. Confidential	James Ellroy
L.A. Confidential	Brian Helgeland
La haine	Mathieu Kassovitz
La haine	Mathieu Kassovitz
La haine	Vincent Cassel
Lawrence of Arabia	David Lean
Lawrence of Arabia	Robert Bolt
Lawrence of Arabia	Michael Wilson
Léon: The Professional	Luc Besson
Léon: The Professional	Luc Besson
Léon: The Professional	Jean Reno
Life Is Beautiful	Roberto Benigni
Life Is Beautiful	Vincenzo Cerami
Life Is Beautiful	Roberto Benigni
Like Stars on Earth	Aamir Khan
Like Stars on Earth	Amole Gupte
Like Stars on Earth	Darsheel Safary
Lock, Stock and Two Smoking Barrels	Guy Ritchie
Lock, Stock and Two Smoking Barrels	Guy Ritchie
Lock, Stock and Two Smoking Barrels	Jason Flemyng
Logan	James Mangold
Logan	James Mangold
Logan	Scott Frank
M	Fritz Lang
M	Thea von Harbou
M	Fritz Lang
Mad Max: Fury Road	George Miller
Mad Max: Fury Road	George Miller
Mad Max: Fury Road	Brendan McCarthy
Maharaja	Nithilan Saminathan
Maharaja	Nithilan Saminathan
Maharaja	Vijay Sethupathi
Mary and Max	Adam Elliot
Mary and Max	Adam Elliot
Mary and Max	Toni Collette
Memento	Christopher Nolan
Memento	Christopher Nolan
Memento	Jonathan Nolan
Memories of Murder	Bong Joon Ho
Memories of Murder	Bong Joon Ho
Memories of Murder	Kwang-rim Kim
Metropolis	Fritz Lang
Metropolis	Thea von Harbou
Metropolis	Fritz Lang
Million Dollar Baby	Clint Eastwood
Million Dollar Baby	Paul Haggis
Million Dollar Baby	F.X. Toole
Modern Times	Charles Chaplin
Modern Times	Charles Chaplin
Modern Times	Charles Chaplin
Monsters, Inc.	Pete Docter
Monsters, Inc.	David Silverman
Monsters, Inc.	Lee Unkrich
Monty Python and the Holy Grail	Terry Gilliam
Monty Python and the Holy Grail	Terry Jones
Monty Python and the Holy Grail	Graham Chapman
Mr. Smith Goes to Washington	Frank Capra
Mr. Smith Goes to Washington	Sidney Buchman
Mr. Smith Goes to Washington	Lewis R. Foster
My Father and My Son	Çagan Irmak
My Father and My Son	Çagan Irmak
My Father and My Son	Çetin Tekindor
My Neighbor Totoro	Hayao Miyazaki
My Neighbor Totoro	Hayao Miyazaki
My Neighbor Totoro	Noriko Hidaka
Network	Sidney Lumet
Network	Paddy Chayefsky
Network	Faye Dunaway
No Country for Old Men	Ethan Coen
No Country for Old Men	Joel Coen
No Country for Old Men	Joel Coen
North by Northwest	Alfred Hitchcock
North by Northwest	Ernest Lehman
North by Northwest	Cary Grant
Oldboy	Park Chan-wook
Oldboy	Garon Tsuchiya
Oldboy	Nobuaki Minegishi
On the Waterfront	Elia Kazan
On the Waterfront	Budd Schulberg
On the Waterfront	Malcolm Johnson
Once Upon a Time in America	Sergio Leone
Once Upon a Time in America	Harry Grey
Once Upon a Time in America	Leonardo Benvenuti
Once Upon a Time in the West	Sergio Leone
Once Upon a Time in the West	Sergio Donati
Once Upon a Time in the West	Sergio Leone
One Battle After Another	Paul Thomas Anderson
One Battle After Another	Paul Thomas Anderson
One Battle After Another	Thomas Pynchon
One Flew Over the Cuckoo's Nest	Milos Forman
One Flew Over the Cuckoo's Nest	Lawrence Hauben
One Flew Over the Cuckoo's Nest	Bo Goldman
Oppenheimer	Christopher Nolan
Oppenheimer	Christopher Nolan
Oppenheimer	Kai Bird
Pan's Labyrinth	Guillermo del Toro
Pan's Labyrinth	Guillermo del Toro
Pan's Labyrinth	Ivana Baquero
Parasite	Bong Joon Ho
Parasite	Bong Joon Ho
Parasite	Han Jin-won
Paths of Glory	Stanley Kubrick
Paths of Glory	Stanley Kubrick
Paths of Glory	Calder Willingham
Pirates of the Caribbean: The Curse of the Black Pearl	Gore Verbinski
Pirates of the Caribbean: The Curse of the Black Pearl	Ted Elliott
Pirates of the Caribbean: The Curse of the Black Pearl	Terry Rossio
Platoon	Oliver Stone
Platoon	Oliver Stone
Platoon	Keith David
Princess Mononoke	Hayao Miyazaki
Princess Mononoke	Hayao Miyazaki
Princess Mononoke	Yôji Matsuda
Prisoners	Denis Villeneuve
Prisoners	Aaron Guzikowski
Prisoners	Hugh Jackman
Psycho	Alfred Hitchcock
Psycho	Joseph Stefano
Psycho	Robert Bloch
Pulp Fiction	Quentin Tarantino
Pulp Fiction	Quentin Tarantino
Pulp Fiction	Roger Avary
Raging Bull	Martin Scorsese
Raging Bull	Jake LaMotta
Raging Bull	Joseph Carter
Raiders of the Lost Ark	Steven Spielberg
Raiders of the Lost Ark	Lawrence Kasdan
Raiders of the Lost Ark	George Lucas
Ran	Akira Kurosawa
Ran	Akira Kurosawa
Ran	Hideo Oguni
Rashomon	Akira Kurosawa
Rashomon	Ryûnosuke Akutagawa
Rashomon	Akira Kurosawa
Ratatouille	Brad Bird
Ratatouille	Jan Pinkava
Ratatouille	Brad Bird
Rear Window	Alfred Hitchcock
Rear Window	John Michael Hayes
Rear Window	Cornell Woolrich
Requiem for a Dream	Darren Aronofsky
Requiem for a Dream	Hubert Selby Jr.
Requiem for a Dream	Darren Aronofsky
Reservoir Dogs	Quentin Tarantino
Reservoir Dogs	Quentin Tarantino
Reservoir Dogs	Roger Avary
Rocky	John G. Avildsen
Rocky	Sylvester Stallone
Rocky	Sylvester Stallone
Room	Lenny Abrahamson
Room	Emma Donoghue
Room	Brie Larson
Rush	Ron Howard
Rush	Peter Morgan
Rush	Chris Hemsworth
Saving Private Ryan	Steven Spielberg
Saving Private Ryan	Robert Rodat
Saving Private Ryan	Tom Hanks
Scarface	Brian De Palma
Scarface	Oliver Stone
Scarface	Howard Hawks
Schindler's List	Steven Spielberg
Schindler's List	Thomas Keneally
Schindler's List	Steven Zaillian
Se7en	David Fincher
Se7en	Andrew Kevin Walker
Se7en	Morgan Freeman
Seven Samurai	Akira Kurosawa
Seven Samurai	Akira Kurosawa
Seven Samurai	Shinobu Hashimoto
Sherlock Jr.	Buster Keaton
Sherlock Jr.	Jean C. Havez
Sherlock Jr.	Joseph A. Mitchell
Shutter Island	Martin Scorsese
Shutter Island	Laeta Kalogridis
Shutter Island	Dennis Lehane
Singin' in the Rain	Stanley Donen
Singin' in the Rain	Gene Kelly
Singin' in the Rain	Betty Comden
Snatch	Guy Ritchie
Snatch	Guy Ritchie
Snatch	Ade
Some Like It Hot	Billy Wilder
Some Like It Hot	Billy Wilder
Some Like It Hot	I.A.L. Diamond
Spider-Man: Across the Spider-Verse	Joaquim Dos Santos
Spider-Man: Across the Spider-Verse	Kemp Powers
Spider-Man: Across the Spider-Verse	Justin K. Thompson
Spider-Man: Into the Spider-Verse	Bob Persichetti
Spider-Man: Into the Spider-Verse	Peter Ramsey
Spider-Man: Into the Spider-Verse	Rodney Rothman
Spider-Man: No Way Home	Jon Watts
Spider-Man: No Way Home	Chris McKenna
Spider-Man: No Way Home	Erik Sommers
Spirited Away	Hayao Miyazaki
Spirited Away	Hayao Miyazaki
Spirited Away	Rumi Hiiragi
Spotlight	Tom McCarthy
Spotlight	Josh Singer
Spotlight	Tom McCarthy
Stand by Me	Rob Reiner
Stand by Me	Stephen King
Stand by Me	Raynold Gideon
Star Wars: Episode IV - A New Hope	George Lucas
Star Wars: Episode IV - A New Hope	George Lucas
Star Wars: Episode IV - A New Hope	Mark Hamill
Star Wars: Episode V - The Empire Strikes Back	Irvin Kershner
Star Wars: Episode V - The Empire Strikes Back	Leigh Brackett
Star Wars: Episode V - The Empire Strikes Back	Lawrence Kasdan
Star Wars: Episode VI - Return of the Jedi	Richard Marquand
Star Wars: Episode VI - Return of the Jedi	Lawrence Kasdan
Star Wars: Episode VI - Return of the Jedi	George Lucas
Sunset Boulevard	Billy Wilder
Sunset Boulevard	Charles Brackett
Sunset Boulevard	Billy Wilder
Taxi Driver	Martin Scorsese
Taxi Driver	Paul Schrader
Taxi Driver	Diahnne Abbott
Terminator 2: Judgment Day	James Cameron
Terminator 2: Judgment Day	James Cameron
Terminator 2: Judgment Day	William Wisher
The Apartment	Billy Wilder
The Apartment	Billy Wilder
The Apartment	I.A.L. Diamond
The Battle of Algiers	Gillo Pontecorvo
The Battle of Algiers	Franco Solinas
The Battle of Algiers	Gillo Pontecorvo
The Best of Youth	Marco Tullio Giordana
The Best of Youth	Sandro Petraglia
The Best of Youth	Stefano Rulli
The Best Years of Our Lives	William Wyler
The Best Years of Our Lives	Robert E. Sherwood
The Best Years of Our Lives	MacKinlay Kantor
The Big Lebowski	Joel Coen
The Big Lebowski	Ethan Coen
The Big Lebowski	Ethan Coen
The Bridge on the River Kwai	David Lean
The Bridge on the River Kwai	Pierre Boulle
The Bridge on the River Kwai	Carl Foreman
The Chaos Class Failed the Class	Ertem Egilmez
The Chaos Class Failed the Class	Sadik Sendil
The Chaos Class Failed the Class	Rifat Ilgaz
The Dark Knight	Christopher Nolan
The Dark Knight	Jonathan Nolan
The Dark Knight	Christopher Nolan
The Dark Knight Rises	Christopher Nolan
The Dark Knight Rises	Jonathan Nolan
The Dark Knight Rises	Christopher Nolan
The Deer Hunter	Michael Cimino
The Deer Hunter	Michael Cimino
The Deer Hunter	Deric Washburn
The Departed	Martin Scorsese
The Departed	William Monahan
The Departed	Alan Mak
The Elephant Man	David Lynch
The Elephant Man	Christopher De Vore
The Elephant Man	Eric Bergren
The Exorcist	William Friedkin
The Exorcist	William Peter Blatty
The Exorcist	Ellen Burstyn
The Father	Florian Zeller
The Father	Christopher Hampton
The Father	Florian Zeller
The General	Clyde Bruckman
The General	Buster Keaton
The General	Buster Keaton
The Godfather	Francis Ford Coppola
The Godfather	Mario Puzo
The Godfather	Francis Ford Coppola
The Godfather Part II	Francis Ford Coppola
The Godfather Part II	Francis Ford Coppola
The Godfather Part II	Mario Puzo
The Gold Rush	Charles Chaplin
The Gold Rush	Charles Chaplin
The Gold Rush	Charles Chaplin
The Good, the Bad and the Ugly	Sergio Leone
The Good, the Bad and the Ugly	Luciano Vincenzoni
The Good, the Bad and the Ugly	Sergio Leone
The Grand Budapest Hotel	Wes Anderson
The Grand Budapest Hotel	Stefan Zweig
The Grand Budapest Hotel	Wes Anderson
The Grapes of Wrath	John Ford
The Grapes of Wrath	Nunnally Johnson
The Grapes of Wrath	John Steinbeck
The Great Dictator	Charles Chaplin
The Great Dictator	Charles Chaplin
The Great Dictator	Charles Chaplin
The Great Escape	John Sturges
The Great Escape	Paul Brickhill
The Great Escape	James Clavell
The Green Mile	Frank Darabont
The Green Mile	Stephen King
The Green Mile	Frank Darabont
The Handmaiden	Park Chan-wook
The Handmaiden	Chung Seo-kyung
The Handmaiden	Sarah Waters
The Help	Tate Taylor
The Help	Tate Taylor
The Help	Kathryn Stockett
The Hunt	Thomas Vinterberg
The Hunt	Thomas Vinterberg
The Hunt	Tobias Lindholm
The Incredibles	Brad Bird
The Incredibles	Brad Bird
The Incredibles	Craig T. Nelson
The Intouchables	Olivier Nakache
The Intouchables	Éric Toledano
The Intouchables	Olivier Nakache
The Iron Giant	Brad Bird
The Iron Giant	Tim McCanlies
The Iron Giant	Brad Bird
The Kid	Charles Chaplin
The Kid	Charles Chaplin
The Kid	Charles Chaplin
The Lion King	Roger Allers
The Lion King	Rob Minkoff
The Lion King	Irene Mecchi
The Lives of Others	Florian Henckel von Donnersmarck
The Lives of Others	Florian Henckel von Donnersmarck
The Lives of Others	Martina Gedeck
The Lord of the Rings: The Fellowship of the Ring	Peter Jackson
The Lord of the Rings: The Fellowship of the Ring	J.R.R. Tolkien
The Lord of the Rings: The Fellowship of the Ring	Fran Walsh
The Lord of the Rings: The Return of the King	Peter Jackson
The Lord of the Rings: The Return of the King	J.R.R. Tolkien
The Lord of the Rings: The Return of the King	Fran Walsh
The Lord of the Rings: The Two Towers	Peter Jackson
The Lord of the Rings: The Two Towers	J.R.R. Tolkien
The Lord of the Rings: The Two Towers	Fran Walsh
The Matrix	Lana Wachowski
The Matrix	Lilly Wachowski
The Matrix	Lilly Wachowski
The Passion of Joan of Arc	Carl Theodor Dreyer
The Passion of Joan of Arc	Joseph Delteil
The Passion of Joan of Arc	Carl Theodor Dreyer
The Pianist	Roman Polanski
The Pianist	Ronald Harwood
The Pianist	Wladyslaw Szpilman
The Prestige	Christopher Nolan
The Prestige	Jonathan Nolan
The Prestige	Christopher Nolan
The Secret in Their Eyes	Juan José Campanella
The Secret in Their Eyes	Eduardo Sacheri
The Secret in Their Eyes	Juan José Campanella
The Seventh Seal	Ingmar Bergman
The Seventh Seal	Ingmar Bergman
The Seventh Seal	Gunnar Björnstrand
The Shawshank Redemption	Frank Darabont
The Shawshank Redemption	Stephen King
The Shawshank Redemption	Frank Darabont
The Shining	Stanley Kubrick
The Shining	Stephen King
The Shining	Stanley Kubrick
The Silence of the Lambs	Jonathan Demme
The Silence of the Lambs	Thomas Harris
The Silence of the Lambs	Ted Tally
The Sixth Sense	M. Night Shyamalan
The Sixth Sense	M. Night Shyamalan
The Sixth Sense	Bruce Willis
The Sound of Music	Robert Wise
The Sound of Music	Georg Hurdalek
The Sound of Music	Howard Lindsay
The Sting	George Roy Hill
The Sting	David S. Ward
The Sting	Paul Newman
The Terminator	James Cameron
The Terminator	James Cameron
The Terminator	Gale Anne Hurd
The Thing	John Carpenter
The Thing	Bill Lancaster
The Thing	John W. Campbell Jr.
The Third Man	Carol Reed
The Third Man	Graham Greene
The Third Man	Alexander Korda
The Treasure of the Sierra Madre	John Huston
The Treasure of the Sierra Madre	John Huston
The Treasure of the Sierra Madre	B. Traven
The Truman Show	Peter Weir
The Truman Show	Andrew Niccol
The Truman Show	Jim Carrey
The Usual Suspects	Bryan Singer
The Usual Suspects	Christopher McQuarrie
The Usual Suspects	Stephen Baldwin
The Wages of Fear	Henri-Georges Clouzot
The Wages of Fear	Georges Arnaud
The Wages of Fear	Henri-Georges Clouzot
The Wild Robot	Chris Sanders
The Wild Robot	Chris Sanders
The Wild Robot	Peter Brown
The Wizard of Oz	Victor Fleming
The Wizard of Oz	George Cukor
The Wizard of Oz	Norman Taurog
The Wolf of Wall Street	Martin Scorsese
The Wolf of Wall Street	Terence Winter
The Wolf of Wall Street	Jordan Belfort
There Will Be Blood	Paul Thomas Anderson
There Will Be Blood	Paul Thomas Anderson
There Will Be Blood	Upton Sinclair
Three Billboards Outside Ebbing, Missouri	Martin McDonagh
Three Billboards Outside Ebbing, Missouri	Martin McDonagh
Three Billboards Outside Ebbing, Missouri	Frances McDormand
To Be or Not to Be	Ernst Lubitsch
To Be or Not to Be	Melchior Lengyel
To Be or Not to Be	Edwin Justus Mayer
To Kill a Mockingbird	Robert Mulligan
To Kill a Mockingbird	Harper Lee
To Kill a Mockingbird	Horton Foote
Tokyo Story	Yasujirô Ozu
Tokyo Story	Kôgo Noda
Tokyo Story	Yasujirô Ozu
Top Gun: Maverick	Joseph Kosinski
Top Gun: Maverick	Jim Cash
Top Gun: Maverick	Jack Epps Jr.
Toy Story	John Lasseter
Toy Story	John Lasseter
Toy Story	Pete Docter
Toy Story 3	Lee Unkrich
Toy Story 3	John Lasseter
Toy Story 3	Andrew Stanton
Trainspotting	Danny Boyle
Trainspotting	Irvine Welsh
Trainspotting	John Hodge
Unforgiven	Clint Eastwood
Unforgiven	David Webb Peoples
Unforgiven	Clint Eastwood
Up	Pete Docter
Up	Bob Peterson
Up	Pete Docter
V for Vendetta	James McTeigue
V for Vendetta	Lilly Wachowski
V for Vendetta	Lana Wachowski
Vertigo	Alfred Hitchcock
Vertigo	Alec Coppel
Vertigo	Samuel A. Taylor
WALL·E	Andrew Stanton
WALL·E	Andrew Stanton
WALL·E	Pete Docter
Warrior	Gavin O'Connor
Warrior	Gavin O'Connor
Warrior	Anthony Tambakis
Whiplash	Damien Chazelle
Whiplash	Damien Chazelle
Whiplash	Miles Teller
Wild Strawberries	Ingmar Bergman
Wild Strawberries	Ingmar Bergman
Wild Strawberries	Victor Sjöström
Wild Tales	Damián Szifron
Wild Tales	Julian Loyola
Wild Tales	Germán Servidio
Witness for the Prosecution	Billy Wilder
Witness for the Prosecution	Agatha Christie
Witness for the Prosecution	Billy Wilder
Yojimbo	Akira Kurosawa
Yojimbo	Akira Kurosawa
Yojimbo	Ryûzô Kikushima
Your Name.	Makoto Shinkai
Your Name.	Makoto Shinkai
Your Name.	Ryûnosuke Kamiki



-- Filtrar por actor específico (ejemplo: Morgan Freeman)
SELECT titulo, anio, calificacion
FROM vista_peliculas_actores
WHERE actor_principal LIKE '%Morgan Freeman%'
ORDER BY calificacion DESC;


-- respuesta

titulo, anio, calificacion
The Shawshank Redemption	1994	9.3
Se7en	1995	8.6
Unforgiven	1992	8.2

-- 5. Índices optimizados para consultas frecuentes


-- Índice para búsquedas por año y calificación
CREATE INDEX idx_peliculas_anio_calificacion ON peliculas(anio, calificacion);

-- Índice para búsquedas por duración
CREATE INDEX idx_peliculas_duracion ON peliculas(duracion);

-- Índice para búsquedas de actores por película
CREATE INDEX idx_actores_pelicula_id ON actores(pelicula_id);

-- Índice para búsquedas de películas por título
CREATE INDEX idx_peliculas_titulo ON peliculas(titulo);


