INSERT INTO majorcsgo (edicao, local, data)
VALUES (1, 'Rio', '2022-08-11');

INSERT INTO mapa (nome)
VALUES ('Dust 2');

INSERT INTO organizacao (nome)
VALUES ('MIBR'),
       ('Astralis');

INSERT INTO jogador (nome)
VALUES ('Fallen'),
       ('jogador1'),
       ('jogador2'),
       ('jogador3'),
       ('jogador4'),
       ('jogador5'),
       ('jogador6'),
       ('jogador7'),
       ('jogador8'),
       ('jogador9');

INSERT INTO equipe (id_organizacao, id_jogador_1, id_jogador_2, id_jogador_3, id_jogador_4, id_jogador_5)
VALUES (1, 1, 2, 3, 4, 5),
       (2, 6, 7, 8, 9, 10);

INSERT INTO equipe_major (id_major, id_equipe)
VALUES (1, 1),
       (1, 2);

INSERT INTO partida (id_major, id_equipe_mandante, id_equipe_visitante, id_equipe_vencedora)
VALUES (1, 1, 2, 1);

INSERT INTO turno (id_partida, id_mapa, id_equipe_vencedora)
VALUES (1, 1, 1),
       (1, 1, 2),
       (1, 1, 1);

INSERT INTO rodada (id_turno, id_equipe_vencedora)
VALUES (1, 1),
       (1, 1),
       (1, 1),
       (1, 1),
       (1, 1),
       (1, 2),
       (1, 2);