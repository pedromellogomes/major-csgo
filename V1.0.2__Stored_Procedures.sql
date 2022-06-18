/**
  1. Dado partida X, retorna a quantidade de turnos já jogados.
 */
CREATE OR REPLACE FUNCTION conta_turnos_por_partida(
    idPartida int
) RETURNS integer AS
$$
    BEGIN
        RETURN (SELECT COUNT(*)
                FROM turno t,
                     partida p
                WHERE t.id_partida = p.id
                AND p.id = idPartida);
    END;
$$
LANGUAGE plpgsql;

/**
  2. Dada partida X, retorna verdadeiro se uma das equipe já venceu dois turnos.
 */
CREATE OR REPLACE FUNCTION alguma_equipe_venceu_dois_turnos_na_mesma_partida(
    idPartida int
) RETURNS boolean AS
$$
BEGIN
    RETURN (SELECT COUNT(*)
            FROM partida p, turno t
            WHERE p.id = idPartida
              AND t.id_partida = p.id
              AND t.id_equipe_vencedora = p.id_equipe_mandante) = 2
        OR
           (SELECT COUNT(*)
            FROM partida p, turno t
            WHERE p.id = idPartida
              AND t.id_partida = p.id
              AND t.id_equipe_vencedora = p.id_equipe_visitante) = 2;
END;
$$
    LANGUAGE plpgsql;

/**
  3. Dado turno X, retorna quantas rodadas foram ganhas pela equipe Y.
 */
CREATE OR REPLACE FUNCTION conta_rodadas_ganhas_por_equipe_em_determinado_turno(
    idTurno int, idEquipeVencedora int
) RETURNS integer AS
$$
    BEGIN
        RETURN (SELECT COUNT(*)
                FROM rodada r,
                     turno t
                WHERE r.id_turno = idTurno
                  AND r.id_equipe_vencedora = idEquipeVencedora);
    END;
$$
LANGUAGE plpgsql;

/**
  4. Dado turno X,
 */
CREATE OR REPLACE FUNCTION conta_rodadas_por_turno(
    idTurno int
) RETURNS integer AS
$$
BEGIN
    RETURN (SELECT COUNT(*)
            FROM rodada r, turno t
            WHERE t.id = idTurno);
END;
$$
    LANGUAGE plpgsql;

/**
  5. Dado turno X, calcula a diferença de turnos ganhos entre as equipes.
 */
CREATE OR REPLACE FUNCTION diferenca_de_vitorias_entre_equipe_por_turno(
    idTurno int
) RETURNS integer AS
$$
BEGIN
    RETURN (SELECT COUNT(*)
            FROM rodada r, turno t, partida p
            WHERE t.id = idTurno
              AND t.id_equipe_vencedora = p.id_equipe_mandante)
        -
           (SELECT COUNT(*)
            FROM rodada r, turno t, partida p
            WHERE t.id = idTurno
              AND t.id_equipe_vencedora = p.id_equipe_visitante);
END;
$$
    LANGUAGE plpgsql;

/**
  6. Dado turno X, insere novo registro se:
    ( quantidade_rodadas >= 31 )
        &&
    ( vitoria_visitante - vitoria_mandante >= [2, -2] )
 */
CREATE OR REPLACE FUNCTION valida_se_turno_terminou_antes_de_inserir_nova_rodada()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
    RAISE NOTICE 'Valida se turno já alcançou total de rodadas permitido.';

    IF conta_rodadas_por_turno(NEW.id_turno) >= 31 AND
       diferenca_de_vitorias_entre_equipe_por_turno(NEW.id_turno) >= 2 THEN
        RAISE NOTICE 'Já ocorreram 31 ou mais rodadas e a diferença de rodadas vencidas pelas equipes é 2 ou mais';
        RETURN NULL;
    ELSE
        RAISE NOTICE 'Ainda não foram jogadas as 31 rodadas mínimas ou a diferença de rodadas vencidas pelas equipes não é 2 ou mais';
        INSERT INTO rodada (id_turno, id_equipe_vencedora) VALUES (NEW.id_turno, NEW.id_equipe_vencedora);
        RETURN NEW;
    END IF;
END;
$$;

/**
  7. Dado partida X, insere novo registro se:
    ( quantidade_turnos < 3 )
        ||
    ( COUNT(id_equipe_vencedora) < 2 )
 */
CREATE OR REPLACE FUNCTION valida_se_partida_terminou_antes_de_inserir_nova_turno()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
    RAISE NOTICE 'Valida se partida já alcançou total de turnos permitido.';

    IF conta_turnos_por_partida(NEW.id_partida) >= 3 OR
       alguma_equipe_venceu_dois_turnos_na_mesma_partida(NEW.id_partida) THEN
        RAISE NOTICE 'Já ocorreram três turnos para a mesma partida ou uma equipe já venceu duas partidas';
        RETURN NULL;
    ELSE
        RAISE NOTICE 'Ainda não ocorreram três turnos para a mesma partida ou uma equipe ainda não venceu duas partidas';
        INSERT INTO turno (id_partida, id_mapa, id_equipe_vencedora) VALUES (NEW.id_partida, NEW.id_mapa, NEW.id_equipe_vencedora);
        RETURN NEW;
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION atualiza_estatisticas_jogador()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS
$$
    DECLARE
        jogador estatisticas_jogador_rodada%ROWTYPE;
BEGIN
    RAISE NOTICE 'Atualizar as estatisticas do jogador a cada nova rodada jogada.';
    SELECT * INTO jogador FROM estatisticas_jogador WHERE id_jogador = NEW.id_jogador;
    IF NOT FOUND THEN
        RAISE NOTICE 'NAO FOI ENCONTRADO';
        INSERT INTO estatisticas_jogador (id_jogador, matou, assistencia, morreu)
        VALUES (NEW.id_jogador, NEW.matou, NEW.assistencia, NEW.morreu);
    ELSE
        RAISE NOTICE 'FOI ENCONTRADO';
        UPDATE estatisticas_jogador
        SET matou = matou + NEW.matou,
            assistencia = assistencia + NEW.assistencia,
            morreu = morreu + NEW.morreu
        WHERE id_jogador = NEW.id_jogador;
    END IF;

    RETURN NEW;
END;
$$;