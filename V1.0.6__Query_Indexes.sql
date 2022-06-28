/**
    1.
 */
CREATE UNIQUE INDEX equipe_major_posicao_idx ON equipe_major (posicao_tabela);

/**
    2.
 */
CREATE UNIQUE INDEX equipe_jogador_idx ON equipe (id_jogador_1, id_jogador_2, id_jogador_3, id_jogador_4, id_jogador_5);