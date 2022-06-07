INSERT INTO majorcsgo (edicao, local, data)
VALUES (1, 'Rio', '2022-08-11');

INSERT INTO equipe (nome)
VALUES ('MIBR'),
       ('Astralis');

INSERT INTO mapa (nome)
VALUES ('Dust 2');

INSERT INTO partida (id_major, id_equipe_mandante, id_equipe_visitante, id_equipe_ganhadora)
VALUES (1, 1, 2, 1);

INSERT INTO turno (id_mapa, id_equipe_vencedora)
VALUES (1, 1),
       (1, 2),
       (1, 1);

INSERT INTO rodada (id_turno, id_equipe_vencedora)
VALUES (1, 1),
       (1, 1),
       (1, 1),
       (1, 1),
       (1, 1),
       (1, 2),
       (1, 2);