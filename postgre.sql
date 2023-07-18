CREATE TABLE Bairro (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(64) NOT NULL,
    regiao VARCHAR(64)
);

CREATE TABLE Logradouro (
    id SERIAL PRIMARY KEY,
    bairro_id INTEGER NOT NULL,
    cep VARCHAR(8) NOT NULL,
    numero INTEGER NOT NULL,
    complemento VARCHAR(64),
    FOREIGN KEY (bairro_id) REFERENCES Bairro (id)
);

CREATE TABLE PontoDeInteresse (
    id SERIAL PRIMARY KEY,
    logradouro_id INTEGER NOT NULL,
    nome VARCHAR(64) NOT NULL,
    lat NUMERIC(10, 8) NOT NULL,
    lon NUMERIC(11, 8) NOT NULL,
    FOREIGN KEY (logradouro_id) REFERENCES Logradouro (id)
);

CREATE TABLE Categoria (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(64) NOT NULL,
    descricao TEXT NOT NULL
);

CREATE TABLE EstabelecimentoComercial (
    id SERIAL PRIMARY KEY,
    ponto_de_interesse_id INTEGER NOT NULL,
    horario_de_funcionamento VARCHAR(64) NOT NULL,
    classificacao_preco NUMERIC(3, 2) NOT NULL,
    formas_de_pagamento VARCHAR(128),
    FOREIGN KEY (ponto_de_interesse_id) REFERENCES PontoDeInteresse (id)
);

CREATE TABLE PontoDeLazer (
    id SERIAL PRIMARY KEY,
    ponto_de_interesse_id INTEGER NOT NULL,
    horario_de_funcionamento VARCHAR(64) NOT NULL,
    atividades_disponiveis VARCHAR(256),
    FOREIGN KEY (ponto_de_interesse_id) REFERENCES PontoDeInteresse (id)
);

CREATE TABLE Residencia (
    id SERIAL PRIMARY KEY,
    ponto_de_interesse_id INTEGER NOT NULL,
    usuario_id INTEGER,
    FOREIGN KEY (ponto_de_interesse_id) REFERENCES PontoDeInteresse (id),
    FOREIGN KEY (usuario_id) REFERENCES Usuario (id)
);

CREATE TABLE Evento (
    id SERIAL PRIMARY KEY,
    ponto_de_lazer_id INTEGER NOT NULL,
    nome VARCHAR(64) NOT NULL,
    inicio TIMESTAMP NOT NULL,
    fim TIMESTAMP NOT NULL,
    descricao TEXT,
    FOREIGN KEY (ponto_de_lazer_id) REFERENCES PontoDeLazer (id)
);

CREATE TABLE Usuario (
    id SERIAL PRIMARY KEY,
    nome_de_usuario VARCHAR(64) NOT NULL UNIQUE,
    email VARCHAR(64) NOT NULL UNIQUE,
    data_de_nascimento DATE NOT NULL
);

CREATE TABLE UsuarioAvaliador (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER NOT NULL UNIQUE,
    nome_publico VARCHAR(64) NOT NULL UNIQUE,
    FOREIGN KEY (usuario_id) REFERENCES Usuario (id)
);

CREATE TABLE Participacao (
    id_evento INTEGER NOT NULL,
    id_usuario INTEGER NOT NULL,
    PRIMARY KEY (id_evento, id_usuario),
    FOREIGN KEY (id_evento) REFERENCES Evento (id),
    FOREIGN KEY (id_usuario) REFERENCES Usuario (id)
);

CREATE TABLE Avaliacao (
    id_avaliador INTEGER NOT NULL,
    id_estabelecimento INTEGER NOT NULL,
    nota NUMERIC(2, 1) NOT NULL CHECK (nota >= 0 AND nota <= 10),
    comentario TEXT,
    PRIMARY KEY (id_avaliador, id_estabelecimento),
    FOREIGN KEY (id_avaliador) REFERENCES UsuarioAvaliador (id),
    FOREIGN KEY (id_estabelecimento) REFERENCES EstabelecimentoComercial (id)
);

CREATE TABLE ListaDePontosDeInteresse (
    id_usuario INTEGER NOT NULL,
    id_pdi INTEGER NOT NULL,
    PRIMARY KEY (id_usuario, id_pdi),
    FOREIGN KEY (id_usuario) REFERENCES Usuario (id),
    FOREIGN KEY (id_pdi) REFERENCES PontoDeInteresse (id)
);

CREATE TABLE Classificacao (
    id_estabelecimento INTEGER NOT NULL,
    id_categoria INTEGER NOT NULL,
    PRIMARY KEY (id_estabelecimento, id_categoria),
    FOREIGN KEY (id_estabelecimento) REFERENCES EstabelecimentoComercial (id),
    FOREIGN KEY (id_categoria) REFERENCES Categoria (id)
);

CREATE TABLE RelacaoGeografica (
    id_pdi_origem INTEGER NOT NULL,
    id_pdi_destino INTEGER NOT NULL,
    distancia NUMERIC(10, 2) NOT NULL CHECK (distancia >= 0 AND distancia <= 20005000), 
    tempo_de_viagem INTERVAL NOT NULL CHECK (tempo_de_viagem >= INTERVAL '0 seconds' AND tempo_de_viagem <= INTERVAL '1 year'), -- Tempo máximo de 1 ano (365 dias) em segundos
    tipo_de_relacao VARCHAR(64) NOT NULL,
    PRIMARY KEY (id_pdi_origem, id_pdi_destino),
    FOREIGN KEY (id_pdi_origem) REFERENCES PontoDeInteresse (id),
    FOREIGN KEY (id_pdi_destino) REFERENCES PontoDeInteresse (id)
);

-- Inserção de dados fictícios

INSERT INTO Bairro (nome, regiao) VALUES
    ('Bairro A', 'Região Norte'),
    ('Bairro B', 'Região Sul'),
    ('Bairro C', 'Região Leste');

INSERT INTO Logradouro (bairro_id, cep, numero, complemento) VALUES
    (1, '12345-678', 100, 'Bloco A'),
    (1, '12345-678', 200, 'Bloco B'),
    (2, '87654-321', 50, 'Casa 1'),
    (3, '13579-246', 300, NULL);

INSERT INTO PontoDeInteresse (logradouro_id, nome, lat, lon) VALUES
    (1, 'Restaurante A', -23.5488, -46.6388),
    (1, 'Supermercado B', -23.5502, -46.6362),
    (2, 'Praça C', -23.5543, -46.6339),
    (3, 'Academia D', -23.5488, -46.6487);

INSERT INTO Categoria (nome, descricao) VALUES
    ('Alimentação', 'Estabelecimentos de alimentação em geral'),
    ('Lazer', 'Lugares de entretenimento e lazer'),
    ('Compras', 'Locais para fazer compras');

INSERT INTO EstabelecimentoComercial (ponto_de_interesse_id, horario_de_funcionamento, classificacao_preco, formas_de_pagamento) VALUES
    (1, 'Seg-Sex: 10h-20h; Sáb-Dom: 11h-18h', 4.5, 'Dinheiro, Cartão de Crédito'),
    (2, 'Seg-Sex: 8h-22h', 3.2, 'Dinheiro, Cartão de Débito, PIX'),
    (4, 'Seg-Sex: 6h-22h; Sáb: 8h-16h', 4.8, 'Cartão de Crédito, PIX');

INSERT INTO PontoDeLazer (ponto_de_interesse_id, horario_de_funcionamento, atividades_disponiveis) VALUES
    (3, 'Todos os dias: 9h-22h', 'Quadras de esporte, Playground'),
    (4, 'Seg-Sex: 6h-12h, 17h-22h; Sáb: 8h-12h', 'Musculação, Zumba');

INSERT INTO Residencia (ponto_de_interesse_id, usuario_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4);

INSERT INTO Evento (ponto_de_lazer_id, nome, inicio, fim) VALUES
    (1, 'Festival de Comida', '2023-07-20 18:00:00', '2023-07-20 22:00:00'),
    (2, 'Apresentação de Música', '2023-08-05 19:30:00', '2023-08-05 22:00:00');

INSERT INTO Usuario (nome_de_usuario, email, data_de_nascimento) VALUES
    ('user1', 'user1@example.com', '1990-05-15'),
    ('user2', 'user2@example.com', '1985-12-01'),
    ('user3', 'user3@example.com', '1998-07-08');

INSERT INTO UsuarioAvaliador (usuario_id, nome_publico) VALUES
    (1, 'Avaliador1'),
    (2, 'Avaliador2'),
    (3, 'Avaliador3');

INSERT INTO Participacao (id_evento, id_usuario) VALUES
    (1, 1),
    (1, 2),
    (2, 2),
    (2, 3);

INSERT INTO Avaliacao (id_avaliador, id_estabelecimento, nota, comentario) VALUES
    (1, 1, 4.8, 'Comida deliciosa!'),
    (2, 2, 3.5, 'Preços um pouco altos'),
    (3, 3, 4.2, 'Ótima academia');

INSERT INTO ListaDePontosDeInteresse (id_usuario, id_pdi) VALUES
    (1, 1),
    (1, 2),
    (2, 2),
    (2, 3);

INSERT INTO Classificacao (id_estabelecimento, id_categoria) VALUES
    (1, 1),
    (2, 1),
    (3, 2),
    (4, 2);

INSERT INTO RelacaoGeografica (id_pdi_origem, id_pdi_destino, distancia, tempo_de_viagem, tipo_de_relacao) VALUES
    (1, 2, 1500.00, '00:15:00', 'A pé'),
    (1, 3, 2000.00, '00:20:00', 'A pé'),
    (2, 1, 1500.00, '00:12:00', 'A pé'),
    (3, 2, 1000.00, '00:10:00', 'A pé');

