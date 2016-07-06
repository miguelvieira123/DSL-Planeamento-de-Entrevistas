# DSL-Planeamento-de-Entrevistas

##Sinopse
Este website foi criado para facilitar a interação com uma DSL que gera um projeto (ficheiro XML)válido na aplicação:
https://github.com/miguelvieira123/AssistenteEntrevistas

##Arquitetura
<img src="/imgs/DSL.png" width="70%" heigth="70%">
<p>A DSL encontra-se no script PERL, e usa o módulo Marpa::R2 para especificar a grámatica.</p>

##Exemplo
```
name: "Projeto Natura"
meta:
  #"Nome"
  #"Idade"
  #"Sexo"
  #"Estado Civil"
  #"Local de residência"
  #"Profissão"
  #"Formação Académica"
  #"Contacto"

perguntas:
  #"Experiência académica e profissional"
  #"Criação do Projeto (Surgimento da ideia e data/ano de criação)"
  #"Entrada no projeto (caso não seja o criador)"
  #("30">"Idade")"Colaboradores e ex colaboradores"
  #"Objetivo(s) do projeto"
  #"Área(s) de intervenção"
  #"Trabalho realizado"
  #"Neste momento o que se encontra a desenvolver"
  #("José João"regex"Nome")"Planos para o futuro"

urls:
  #"http://www.gpsmon.org/zip1/index.php"
```

#####Códigos dos Operadores
Uma das especificidades desta DSL é o código atribuido a cada um dos operadores válidos na linguagem. A tabela que se segue serve de referencia:

|codigo |   OP|
|-------|------|
|1   |   == |
|2   |   != |
|3   |   <  |
|4   |   >  |
|5   |   <= |
|6   |   >= |
|7   |   regex|

#####Exemplo de Transformação de uma condição
O excerto de uma frase válida,
```
perguntas:
  #("José João" regex "Nome") "Experiência académica e profissional"
  #"Criação do Projeto (Surgimento da ideia e data/ano de criação)"
```
gera o seguinte XML:
```XML
<perguntas>
    <p metafield="Nome" op="7" value="José João">Experiência académica e profissional</p>
    <p>Criação do Projeto (Surgimento da ideia e data/ano de criação)</p>
```
