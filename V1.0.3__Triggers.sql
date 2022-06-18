CREATE TRIGGER valida_se_turno_terminou_antes_de_inserir_nova_rodada
    BEFORE INSERT
    ON rodada
    FOR EACH ROW
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION valida_se_turno_terminou_antes_de_inserir_nova_rodada();

CREATE TRIGGER valida_se_partida_terminou_antes_de_inserir_nova_turno
    BEFORE INSERT
    ON turno
    FOR EACH ROW
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION valida_se_partida_terminou_antes_de_inserir_nova_turno();

CREATE TRIGGER atualiza_estatisticas_jogador
    AFTER INSERT
    ON estatisticas_jogador_rodada
    FOR EACH ROW
EXECUTE FUNCTION atualiza_estatisticas_jogador();