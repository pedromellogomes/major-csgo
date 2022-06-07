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
  6. Dado turno X, retorna verdadeiro se:
    ( quantidade_rodadas >= 31 )
        &&
    ( vitoria_visitante - vitoria_mandante >= [2, -2] )
 */
CREATE OR REPLACE FUNCTION valida_turno(
    idTurno int
) RETURNS boolean AS
$$
BEGIN
    RETURN (SELECT diferenca_de_vitorias_entre_equipe_por_turno(idTurno) >= 2)
        AND
           (SELECT conta_rodadas_por_turno(idTurno) >= 31);
END;
$$
    LANGUAGE plpgsql;