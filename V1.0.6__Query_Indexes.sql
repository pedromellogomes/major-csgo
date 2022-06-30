/** 1. */
CREATE INDEX equipe_major_posicao_idx ON equipe_major (posicao_tabela);

/** 2. */
CREATE INDEX equipe_jogador_idx ON equipe (id_jogador_1, id_jogador_2, id_jogador_3, id_jogador_4, id_jogador_5);

/** 3. */
CREATE INDEX partida_equipe_vencedora_idx ON partida (id_equipe_vencedora);

/** 4. */
CREATE INDEX turno_equipe_vencedora_idx ON turno (id_equipe_vencedora);

/** 5. */
CREATE INDEX rodada_equipe_vencedora_idx ON rodada (id_equipe_vencedora);

/** 6. */
CREATE INDEX estatisticas_jogador_rodada_idx ON estatisticas_jogador_rodada(matou, assistencia, morreu);