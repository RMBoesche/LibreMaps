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
    descricao VARCHAR(256) NOT NULL
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
    usuario_id INTEGER NOT NULL,
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
    tempo_de_viagem INTERVAL NOT NULL CHECK (tempo_de_viagem >= 0 AND tempo_de_viagem <= 31540000), -- Tempo máximo de 1 ano (365 dias) em segundos
    tipo_de_relacao VARCHAR(64) NOT NULL,
    PRIMARY KEY (id_pdi_origem, id_pdi_destino),
    FOREIGN KEY (id_pdi_origem) REFERENCES PontoDeInteresse (id),
    FOREIGN KEY (id_pdi_destino) REFERENCES PontoDeInteresse (id)
);

