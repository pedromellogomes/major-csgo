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

create table equipe
(
    id   serial not null,
    nome varchar(100),

    primary key (id)
);

create table historico_participacao
(
    id        serial  not null,
    id_major  integer not null,
    id_equipe integer not null,

    primary key (id),
    foreign key (id_major) references majorcsgo (id),
    foreign key (id_equipe) references equipe (id)
);

create table jogador
(
    id        serial  not null,
    id_equipe integer not null,
    nome      varchar(100),

    primary key (id),
    foreign key (id_equipe) references equipe (id)
);

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
    foreign key (id_equipe_mandante) references equipe (id),
    foreign key (id_equipe_visitante) references equipe (id),
    foreign key (id_equipe_vencedora) references equipe (id)
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
    foreign key (id_equipe_vencedora) references equipe (id)
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
    foreign key (id_equipe_vencedora) references equipe (id)
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