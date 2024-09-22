---
title: Backend
sidebar_position: 3
---

## Visão Geral

Este documento descreve as atualizações no backend do projeto até o momento atual, abordando novas funcionalidades incluindo a simulação de "Pixies" e seus medicamentos, a criação de funcionalidades para relatos de problemas, e uma ferramenta de chat ao vivo para comunicação entre enfermeiros e a central de atendimento.

## Estrutura do Projeto

O projeto continua a ser desenvolvido em Go com o framework Gin e está estruturado na pasta `server` dentro de `src`. As principais atualizações incluem:

Gerenciar as operações relacionadas às Pixies e seus medicamentos.
Manipular a criação e consulta de problemas pelos usuários.
Implementar o chat ao vivo entre enfermeiros e auxiliares da central.

## Orquestramento com Kubernetes

O projeto agora está configurado para ser orquestrado com Kubernetes. A pasta `src/kubernetes` contém os arquivos de configuração necessários para implantar o backend em um cluster. 

## Funcionalidades do Backend

- **Pixies e Medicamentos**: Gerencia as Pixies e seus medicamentos, incluindo a funcionalidade para identificar a Pixies mais próxima disponível.
- **Relatos de Problemas**: Permite aos usuários relatar problemas que podem estar enfrentando.
- **Chat ao Vivo**: Implementa um sistema de comunicação em tempo real entre enfermeiros e a central de atendimento.

## Testes de Carga**

Os detalhes sobre os testes de carga podem ser encontrados na aba de aplicação de testes.

## Conclusão**

Esta documentação reflete as atualizações feitas no backend do projeto, apresentando as novas funcionalidades implementadas. Futuras atualizações continuarão a expandir a eficiência e robustez do sistema.