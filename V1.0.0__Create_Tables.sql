create table majorcsgo
(
    id     serial  not null,
    edicao integer not null,
    local  varchar(250),
    data   date    not null,

    primary key (id)
);

create table mapa
(
    id   serial not null,
    nome varchar(250),

    primary key (id)
);

create table organizacao
(
    id   serial not null,
    nome varchar(100),

    primary key (id)
);

create table jogador
(
    id        serial  not null,
    nome      varchar(100),

    primary key (id)
);

create table equipe
(
    id serial not null,
    id_organizacao integer not null,
    id_jogador_1 integer not null,
    id_jogador_2 integer not null,
    id_jogador_3 integer not null,
    id_jogador_4 integer not null,
    id_jogador_5 integer not null,

    primary key (id),
    foreign key (id_organizacao) references organizacao (id),
    foreign key (id_jogador_1) references jogador (id),
    foreign key (id_jogador_2) references jogador (id),
    foreign key (id_jogador_3) references jogador (id),
    foreign key (id_jogador_4) references jogador (id),
    foreign key (id_jogador_5) references jogador (id)
);

alter table equipe
    add constraint uk_equipe unique (id_organizacao, id_jogador_1, id_jogador_2, id_jogador_3, id_jogador_4, id_jogador_5);

create table equipe_major
(
    id        serial  not null,
    id_major  integer not null,
    id_equipe integer not null,

    primary key (id),
    foreign key (id_major) references majorcsgo (id),
    foreign key (id_equipe) references equipe (id)
);

alter table equipe_major
    add constraint uk_equipe_major unique (id_major, id_equipe);

/**
 * RESTRIÇÕES
 * Partida ocorre em 3 turnos
 */
create table partida
(
    id                  serial  not null,
    id_major            integer not null,
    id_equipe_mandante  integer not null,
    id_equipe_visitante integer not null,
    id_equipe_vencedora integer,

    primary key (id),
    foreign key (id_major) references majorcsgo (id),
    foreign key (id_equipe_mandante) references equipe_major (id),
    foreign key (id_equipe_visitante) references equipe_major (id),
    foreign key (id_equipe_vencedora) references equipe_major (id)
);

/**
 * RESTRIÇÕES DE NEGÓCIO
 * São 3 turnos por partida.
 * Vence aquele que ganhar 2.
 */
create table turno
(
    id                  serial  not null,
    id_partida          integer not null,
    id_mapa             integer not null,
    id_equipe_vencedora integer,

    primary key (id),
    foreign key (id_partida) references partida (id),
    foreign key (id_mapa) references mapa (id),
    foreign key (id_equipe_vencedora) references equipe_major (id)
);

/**
 * RESTRIÇÕES DE NEGÓCIO
 * Ganha o turno quem vencer 16 rodadas primeiro
 * A diferença entre placar_mandando e placar_visitante deve ser de 2.
 */
create table rodada
(
    id                  serial  not null,
    id_turno            integer not null,
    id_equipe_vencedora integer not null,

    primary key (id),
    foreign key (id_turno) references turno (id),
    foreign key (id_equipe_vencedora) references equipe_major (id)
);

create table estatisticas_jogador_rodada
(
    id          serial  not null,
    id_rodada   integer not null,
    id_jogador  integer not null,
    matou       integer,
    assistencia integer,
    morreu      integer,

    primary key (id),
    foreign key (id_rodada) references rodada (id),
    foreign key (id_jogador) references jogador (id)
);

create table estatisticas_jogador
(
    id          serial  not null,
    id_jogador  integer not null,
    matou       integer not null default 0,
    assistencia integer not null default 0,
    morreu      integer not null default 0,

    primary key (id),
    foreign key (id_jogador) references jogador (id)
);