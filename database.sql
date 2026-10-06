PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS historico_status;
DROP TABLE IF EXISTS solicitacoes;
DROP TABLE IF EXISTS status;
DROP TABLE IF EXISTS categorias;

CREATE TABLE categorias (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL UNIQUE,
    ativo INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0,1))
);

CREATE TABLE status (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL UNIQUE
);

CREATE TABLE solicitacoes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    protocolo TEXT NOT NULL UNIQUE,
    categoria_id INTEGER NOT NULL,
    status_id INTEGER NOT NULL,
    localidade TEXT NOT NULL,
    descricao TEXT NOT NULL,
    data_criacao TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (status_id) REFERENCES status(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE historico_status (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    solicitacao_id INTEGER NOT NULL,
    status_id INTEGER NOT NULL,
    data_alteracao TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    observacao TEXT,
    FOREIGN KEY (solicitacao_id) REFERENCES solicitacoes(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (status_id) REFERENCES status(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX idx_solicitacoes_categoria ON solicitacoes(categoria_id);
CREATE INDEX idx_solicitacoes_status ON solicitacoes(status_id);
CREATE INDEX idx_historico_solicitacao ON historico_status(solicitacao_id);

INSERT INTO categorias (nome) VALUES
('Iluminação'), ('Limpeza'), ('Meio ambiente'), ('Mobilidade'), ('Informação'), ('Outra');

INSERT INTO status (nome) VALUES ('Recebida'), ('Em análise'), ('Concluída');

INSERT INTO solicitacoes (protocolo, categoria_id, status_id, localidade, descricao) VALUES
('SC-1001', 1, 1, 'Jardim-MS', 'Lâmpada apagada em área pública.'),
('SC-1002', 3, 2, 'Jardim-MS', 'Solicitação de manutenção de área verde.');

INSERT INTO historico_status (solicitacao_id, status_id, observacao) VALUES
(1, 1, 'Solicitação registrada.'),
(2, 1, 'Solicitação registrada.'),
(2, 2, 'Solicitação encaminhada para análise.');

-- INSERT
INSERT INTO solicitacoes (protocolo, categoria_id, status_id, localidade, descricao)
VALUES ('SC-1003', 2, 1, 'Jardim-MS', 'Coleta de resíduos em ponto comunitário.');

-- UPDATE
UPDATE solicitacoes
SET status_id = (SELECT id FROM status WHERE nome = 'Em análise'),
    data_atualizacao = CURRENT_TIMESTAMP
WHERE protocolo = 'SC-1003';

INSERT INTO historico_status (solicitacao_id, status_id, observacao)
SELECT id, (SELECT id FROM status WHERE nome = 'Em análise'),
       'Solicitação encaminhada para análise.'
FROM solicitacoes WHERE protocolo = 'SC-1003';

-- SELECT
SELECT s.protocolo, c.nome AS categoria, st.nome AS status,
       s.localidade, s.descricao, s.data_criacao
FROM solicitacoes s
JOIN categorias c ON c.id = s.categoria_id
JOIN status st ON st.id = s.status_id
ORDER BY s.id;

-- SELECT por protocolo
SELECT s.protocolo, c.nome AS categoria, st.nome AS status,
       s.localidade, s.descricao
FROM solicitacoes s
JOIN categorias c ON c.id = s.categoria_id
JOIN status st ON st.id = s.status_id
WHERE s.protocolo = 'SC-1003';

-- DELETE
DELETE FROM solicitacoes WHERE protocolo = 'SC-1003';
