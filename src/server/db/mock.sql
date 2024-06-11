-- Inserindo dados com IDs incrementais no campo Code como inteiro
INSERT INTO products (name, code) VALUES 
('Comp. Dipirona 500mg', 1000),
('Ampola de Ceftriaxona 1g', 1001),
('Comp. Ibuprofeno 200mg', 1002),
('Comp. Paracetamol 750mg', 1003),
('Comp. Aspirina 100mg', 1004),
('Comp. Amoxicilina 500mg', 1005),
('Comp. Clonazepam 2mg', 1006),
('Comp. Enalapril 10mg', 1007),
('Seringa Insulina 1ml', 1008),
('Soro Fisiológico 500ml', 1009),
('Comp. Metformina 850mg', 1010),
('Comp. Loratadina 10mg', 1011),
('Amp. Diclofenaco 75mg', 1012),
('Comp. Simeticona 125mg', 1013),
('Comp. Levotiroxina 50mcg', 1014),
('Comp. Losartana 50mg', 1015),
('Comp. Fluconazol 150mg', 1016),
('Comp. Hidroclorotiazida 25mg', 1017),
('Comp. Omeprazol 20mg', 1018),
('Comp. Prednisona 20mg', 1019),
('Amp. de Tramadol 100mg', 1020),
('Comp. Azitromicina 500mg', 1021),
('Comp. Captopril 25mg', 1022),
('Comp. Atenolol 50mg', 1023),
('Comp. Cloridrato de Sertralina 50mg', 1024),
('Comp. Acetilcisteína 600mg', 1025),
('Comp. Cetoconazol 200mg', 1026),
('Comp. Cloridrato de Metoclopramida 10mg', 1027),
('Comp. Fenitoína 100mg', 1028),
('Comp. Sinvastatina 20mg', 1029),
('Luvas Cirúrgicas Estéreis', 1030),
('Sonda Nasogástrica 16Fr', 1031),
('Gaze Estéril 10x10cm', 1032),
('Esparadrapo Micropore 25mm', 1033),
('Cateter Intravenoso 18G', 1034),
('Tubo Endotraqueal 7.5mm', 1035),
('Adesivo Cirúrgico 10cm x 5m', 1036),
('Bisturi Descartável nº 10', 1037),
('Pinça Hemostática', 1038),
('Agulha Hipodérmica 21G', 1039),
('Fita Adesiva Hipoalergênica 5cm', 1040),
('Bandeja de Aço Inoxidável', 1041),
('Seringa de 20ml', 1042),
('Frasco Coletor de Urina 24h', 1043),
('Tesoura Cirúrgica', 1044),
('Campo Operatório Fenestrado', 1045),
('Fio de Sutura Nylon 3-0', 1046),
('Drenagem Portovac 100ml', 1047),
('Compressa de Gaze 7.5x7.5cm', 1048),
('Dispositivo de Infusão Continua', 1049),
('Cânula de Traqueostomia 8.0mm', 1050),
('Cânula de Guedel nº 5', 1051),
('Fita de Antissepsia 1cm', 1052),
('Eletrodo para ECG', 1053),
('Kit de Cateterismo Vesical', 1054),
('Bolsa de Colostomia 70mm', 1055),
('Lanceta para Glicemia', 1056),
('Swab Estéril', 1057);


INSERT INTO pyxis (name) VALUES 
('01-01'),('01-02'),('01-03'),('01-04'),('01-05'),('01-06'),('01-07'),
('01-08'),('02-01'),('02-02'),('02-03'),('02-04'),('03-01'),('03-02'),
('04-01'),('05-01'),('05-02'),('05-03'),('05-04'),('05-05'),('06-01'),
('06-02'),('06-03'),('06-04'),('07-01'),('07-02'),('07-03'),('07-04'),
('07-05'),('08-01'),('08-02'),('09-01'),('10-02');


INSERT INTO users (internal_id, name, is_admin) VALUES
('d033e2', 'Administrador sem nome', true), -- Token: admin
('220aa', 'Lorena dos santos Cunha', true), -- Token: lorena
('fd077', 'Paulo Evangelista', false), -- Token: paulo
('88fa8', 'Victor Zeferino', false), -- Token: victor
('2394e', 'Amanda Fontes', false); -- Token: amanda