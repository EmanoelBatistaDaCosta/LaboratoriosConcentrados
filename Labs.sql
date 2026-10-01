CREATE DATABASE IF NOT EXISTS sistema_laboratorio;
USE sistema_laboratorio;

-- -----------------------------------------------------
-- TABELA: USUARIO
-- -----------------------------------------------------
CREATE TABLE USUARIO (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    tipo VARCHAR(20) DEFAULT 'Aluno', -- Ex: 'Aluno', 'Professor', 'Tecnico', 'Admin'
    autorizado TINYINT(1) DEFAULT 0   -- 0: Não autorizado, 1: Autorizado
);

-- -----------------------------------------------------
-- TABELA: LABORATORIO
-- -----------------------------------------------------
CREATE TABLE LABORATORIO (
    id_laboratorio INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(10) NOT NULL UNIQUE,  -- Ex: 'LAB-A', 'LAB-B', ..., 'LAB-H'
    nome VARCHAR(50) NOT NULL,          -- Ex: 'Lab Informática A'
    tipo VARCHAR(50) DEFAULT 'Informática',
    capacidade INT NOT NULL DEFAULT 30,
    num_computadores INT NOT NULL DEFAULT 30,
    status_funcionamento VARCHAR(20) DEFAULT 'Disponivel', -- 'Disponivel', 'Em Uso', 'Manutencao'
    descricao VARCHAR(255)
);

-- -----------------------------------------------------
-- TABELA: EQUIPAMENTO
-- -----------------------------------------------------
CREATE TABLE EQUIPAMENTO (
    id_equipamento INT AUTO_INCREMENT PRIMARY KEY,
    id_laboratorio INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    quantidade_danificada INT NOT NULL DEFAULT 0,
    estado VARCHAR(20) DEFAULT 'Ok', -- 'Ok', 'Danificado', 'Em Reparo'
    descricao VARCHAR(255),
    data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_equipamento_laboratorio
        FOREIGN KEY (id_laboratorio)
        REFERENCES LABORATORIO(id_laboratorio)
        ON DELETE CASCADE
);

-- -----------------------------------------------------
-- TABELA: RESERVA
-- -----------------------------------------------------
CREATE TABLE RESERVA (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_laboratorio INT NOT NULL,
    data_reserva DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    finalidade VARCHAR(255) NOT NULL,
    status VARCHAR(20) DEFAULT 'Pendente', -- 'Pendente', 'Confirmada', 'Cancelada', 'Concluida'
    autorizacao_confirmada TINYINT(1) DEFAULT 0,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_reserva_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES USUARIO(id_usuario),

    CONSTRAINT fk_reserva_laboratorio
        FOREIGN KEY (id_laboratorio)
        REFERENCES LABORATORIO(id_laboratorio)
);

-- -----------------------------------------------------
-- TABELA: HISTORICO_EVENTO
-- -----------------------------------------------------
CREATE TABLE HISTORICO_EVENTO (
    id_historico INT AUTO_INCREMENT PRIMARY KEY,
    id_laboratorio INT NOT NULL,
    id_usuario INT, -- Pode ser nulo se for evento automático do sistema
    tipo_evento VARCHAR(50) NOT NULL, -- 'Aula', 'Manutencao', 'Reserva', 'Limpeza', 'TrocaEquipamento'
    descricao VARCHAR(255) NOT NULL,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_historico_laboratorio
        FOREIGN KEY (id_laboratorio)
        REFERENCES LABORATORIO(id_laboratorio)
        ON DELETE CASCADE,

    CONSTRAINT fk_historico_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES USUARIO(id_usuario)
        ON DELETE SET NULL
);

-- -----------------------------------------------------
-- POPULAÇÃO INICIAL DOS 8 LABORATORIOS DE INFORMÁTICA (A a H)
-- -----------------------------------------------------
INSERT INTO LABORATORIO (codigo, nome, tipo, capacidade, num_computadores, status_funcionamento, descricao) VALUES
('LAB-A', 'Lab Informática A', 'Informática / Dev', 30, 30, 'Disponivel', 'Laboratório principal para desenvolvimento de sistemas.'),
('LAB-B', 'Lab Informática B', 'Informática / SO', 25, 25, 'Em Uso', 'Focado em sistemas operacionais e arquitetura de software.'),
('LAB-C', 'Lab Informática C', 'Informática / Redes', 20, 20, 'Disponivel', 'Infraestrutura de redes e segurança da informação.'),
('LAB-D', 'Lab Informática D', 'Informática / Hardware', 20, 10, 'Disponivel', 'Manutenção de computadores e arquitetura de hardware.'),
('LAB-E', 'Lab Informática E', 'Informática / Banco de Dados', 25, 25, 'Disponivel', 'Modelagem, administração e otimização de bancos de dados.'),
('LAB-F', 'Lab Informática F', 'Informática / Web', 20, 20, 'Manutencao', 'Programação Web e desenvolvimento de interfaces.'),
('LAB-G', 'Lab Informática G', 'Informática / IA', 25, 25, 'Disponivel', 'Inteligência artificial, ciência de dados e aprendizado de máquina.'),
('LAB-H', 'Lab Informática H', 'Informática / Projetos', 30, 30, 'Disponivel', 'Desenvolvimento do Projeto Integrador e trabalho colaborativo.');