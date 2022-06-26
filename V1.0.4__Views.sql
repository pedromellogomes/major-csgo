/**
    1. Classifica jogadores por número de vítórias (partidas ganhas).
 */
CREATE VIEW ranking_jogadores_com_mais_vitorias AS
SELECT jogador.id, jogador.nome, COUNT(partida.id_equipe_vencedora) as vitorias
FROM jogador,
     equipe,
     equipe_major,
     partida
WHERE equipe.id = equipe_major.id_equipe
  AND equipe_major.id = partida.id_equipe_vencedora
  AND (equipe.id_jogador_1 = jogador.id
    OR equipe.id_jogador_2 = jogador.id
    OR equipe.id_jogador_3 = jogador.id
    OR equipe.id_jogador_4 = jogador.id
    OR equipe.id_jogador_5 = jogador.id)
GROUP BY jogador.id
ORDER BY vitorias DESC;

/**
    2. Classifica equipes por número de vítóras
 */
CREATE VIEW ranking_equipes_com_mais_vitorias AS
SELECT equipe.id, organizacao.nome, COUNT(partida.id_equipe_vencedora) as vitorias
FROM organizacao,
     equipe,
     equipe_major,
     partida
WHERE organizacao.id = equipe.id_organizacao
AND equipe.id = equipe_major.id_equipe
AND equipe_major.id = partida.id_equipe_vencedora
GROUP BY equipe.id, organizacao.nome
ORDER BY vitorias DESC;