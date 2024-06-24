---
title: Finalização da Solução
sidebar_position: 2
---

# Finalização da Solução do Desenvolvimento da Plataforma


Esse é um projeto de construção de uma plataforma mobile e backend para o Hospital Sírio-Libanês visa facilitar o envio de requisições sobre o uso de dispensadores de medicamentos localizados nos diferentes andares do hospital. O Hospital Sírio-Libanês, um dos mais importantes e reconhecidos hospitais do Brasil, situado em São Paulo, na Bela Vista, foi fundado em 1921 e é conhecido por sua inovação médica e compromisso com a qualidade de vida da comunidade.

A necessidade de facilitar a rotina de solicitar e acompanhar os pedidos relacionados aos dispensadores de remédios é evidente. Esses dispensadores possuem diversos medicamentos, incluindo alguns controlados que exigem um controle especial. O sistema deve permitir que os operadores modifiquem as permissões de acesso e solicitação dos medicamentos, além de rastrear todos os itens.

O objetivo do projeto foi construir um sistema que possibilite a solicitação de medicamentos, controle de acesso e integrações com outras soluções utilizando um dispositivo móvel. Espera-se que a solução reduza o tempo para realizar atendimentos, aumente a rastreabilidade dos medicamentos utilizados e construa relatórios dos itens utilizados.

Além do mais, o desenvolvimento do projeto seguiu um roadmap de evolução da solução, dividido em sprints:

Na Sprint I, houve o entendimento do problema, do negócio e do usuário, além da proposta de interface e arquitetura. Na Sprint II, foi realizada a análise financeira, prototipação e implementação inicial do back-end. Durante a Sprint III, foram implementadas funcionalidades e mecanismos de segurança. A Sprint IV focou na integração do mobile e backend, implementação dos testes CI/CD e monitoramento da aplicação. E, por fim, na Sprint V, foi realizado o plano de comunicação, finalização da solução e deste documento.

Vale ressaltar também que os testes realizados incluíram testes de funcionalidade, verificando as requisições de medicamentos e testes de autenticação e autorização; testes de usabilidade, realizados com a System Usability Scale (SUS) com uma pontuação média de 69.25; testes de integração, verificando a integração entre o aplicativo móvel e o backend utilizando Kubernetes; e testes de performance, avaliando o desempenho do backend sob carga.

Os passos necessários para executar a versão atual da solução envolvem a configuração do ambiente, instalação do Docker, clonagem do repositório do projeto (https://github.com/Inteli-College/2024-1B-T02-EC10-G05.git), inicialização dos serviços com `docker-compose up` na pasta src, aplicação dos manifests Kubernetes para deploy dos serviços e acesso à aplicação móvel via dispositivo Android. Após a configuração, é possível enviar e monitorar requisições de medicamentos.

Durante o desenvolvimento, a documentação foi constantemente atualizada para refletir as mudanças e aprimoramentos, incluindo melhorias na arquitetura, interface de usuário e integração de novos componentes de segurança. Além disso, inicialmente, o projeto incluía a implementação de um sistema de login para os usuários, mas essa funcionalidade não foi concluída nesta fase. No entanto, com a continuação do projeto, essa funcionalidade poderá ser implementada para aumentar a segurança e controle de acesso à plataforma.

Em resumo, a entrega desta solução marca um avanço significativo na gestão de medicamentos no Hospital Sírio-Libanês, proporcionando uma maior eficiência operacional e um controle rigoroso sobre o uso de dispensadores. Este projeto não só moderniza os processos internos do hospital, mas também reforça seu compromisso com a excelência e a inovação contínua na área da saúde.

## Vídeo das ações do aplicativo mobile


#### Tela de Ações do Enfermeiro

[![Demonstração do Envio de Requisições de Medicamentos](https://img.youtube.com/vi/nryjFrs5ZFs/1.jpg)](https://youtube.com/shorts/nryjFrs5ZFs)

#### Tela das Ações da Farmácia

[![Demonstração do Envio de Requisições de Medicamentos](https://img.youtube.com/vi/MzpbmI6T8XY/1.jpg)](https://youtube.com/shorts/MzpbmI6T8XY)


