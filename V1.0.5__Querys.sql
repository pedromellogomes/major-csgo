/**
    1. Qual jogador com maior razão KD? razão entre (morreu / matou)
 */
SELECT estatisticas_jogador.id_jogador,
       jogador.nome,
       CAST(estatisticas_jogador.matou AS FLOAT) / CAST(estatisticas_jogador.morreu AS FLOAT) AS KD
FROM estatisticas_jogador,
     jogador
WHERE estatisticas_jogador.id_jogador = jogador.id
ORDER BY KD DESC;

/**
    2. Qual jogador mais participou de equipes diferentes?.
 */
SELECT jogador.id, jogador.nome, COUNT(equipe.id) AS qtd_equipes
FROM jogador,
     equipe
WHERE jogador.id = equipe.id_jogador_1
   OR jogador.id = equipe.id_jogador_2
   OR jogador.id = equipe.id_jogador_3
   OR jogador.id = equipe.id_jogador_4
   OR jogador.id = equipe.id_jogador_5
GROUP BY jogador.id
ORDER BY qtd_equipes DESC;

/**
    3. Qual equipe mais venceu o major?
 */
SELECT equipe.id, equipe.id_organizacao, COUNT(CASE WHEN equipe_major.posicao_tabela = 1 THEN 1 END) AS vitorias
FROM equipe,
     equipe_major
WHERE equipe.id = equipe_major.id_equipe
GROUP BY equipe.id, equipe.id_organizacao
ORDER BY vitorias DESC;

/**
    4. Qual organização mais venceu o major?
 */
SELECT organizacao.id, organizacao.nome, COUNT(CASE WHEN equipe_major.posicao_tabela = 1 THEN 1 END) AS campeao
FROM organizacao,
     equipe,
     equipe_major,
     major
WHERE organizacao.id = equipe.id_organizacao
  AND equipe.id = equipe_major.id_equipe
  AND equipe_major.id_major = major.id
GROUP BY organizacao.id, organizacao.nome
ORDER BY campeao DESC;

/**
    5. Qual mapa mais escolhido nos turnos?
 */
SELECT mapa.id, mapa.nome, COUNT(turno.id_mapa) as qtd_escolhido
FROM mapa,
     turno
WHERE mapa.id = turno.id_mapa
GROUP BY mapa.id, mapa.nome
ORDER BY qtd_escolhido DESC;

/**
    6. Qual o turno mais longo? Mais rodadas foram necessárias para concluir
 */
SELECT turno.id, turno.id_equipe_mandante, turno.id_equipe_visitante, COUNT(rodada.id) AS qtd_rodadas
FROM turno,
     rodada
WHERE rodada.id_turno = turno.id
GROUP BY turno.id
ORDER BY qtd_rodadas DESC;

/**
    7.
 */

/**
    8.
 */

/**
    9.
 */
