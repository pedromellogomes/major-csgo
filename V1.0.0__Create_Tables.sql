create table majorcsgo(
	id serial not null,
	edicao integer not null,
	local varchar(250),
	data date not null,
	
	primary key (id)
);

create table mapa(
	id serial not null,
	nome varchar(250),
	
	primary key (id)
);

create table equipe(
	id serial not null,
	nome varchar(100),
	
	primary key (id)
);

create table historico_participacao(
	id serial not null,
	id_major integer not null,
	id_equipe integer not null,
	
	primary key (id),
	foreign key (id_major) references majorcsgo(id),
	foreign key (id_equipe) references equipe(id)
);

create table jogador(
	id serial not null,
	id_equipe integer not null,
	nome varchar(100),
	
	primary key (id),
	foreign key (id_equipe) references equipe(id)
);

/**
 * RESTRIÇÕES
 * Partida ocorre em 3 turnos
 */
create table partida(
	id serial not null,
	id_major integer not null,
	id_equipe_mandante integer not null,
	id_equipe_visitante integer not null,
	id_equipe_ganhadora integer not null,
	/* TODO: adicionar campo com placar final */
	
	primary key (id),
	foreign key (id_major) references majorcsgo(id),
	foreign key (id_equipe_mandante) references equipe(id),
	foreign key (id_equipe_visitante) references equipe(id),
	foreign key (id_equipe_ganhadora) references equipe(id)
);

/**
 * RESTRIÇÕES
 * Somente 3 turnos podem fazer referência à mesma partida
 */
create table turno(
	id serial not null,
	id_mapa integer not null,
	id_equipe_vencedor integer not null,
	
	primary key (id),
	foreign key (id_mapa) references mapa(id),
	foreign key (id_equipe_vencedor) references equipe(id)
);

/**
 * RESTRIÇÕES
 * Partida ocorre em 3 turnos
 */
create table rodada(
	id serial not null,
	id_turno integer not null,
		
	primary key (id),
	foreign key (id_turno) references turno(id)
);

