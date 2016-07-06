# DSL-Planeamento-de-Entrevistas


##Códigos dos Operadores

|codigo |   OP|
|-------|------|
|1   |   == |
|2   |   != |
|3   |   <  |
|4   |   >  |
|5   |   <= |
|6   |   >= |
|7   |   regex|

#####Exemplo de Transformação de um condição
O excerto de uma frase válida,
```
perguntas:
  #("José João" regex "Nome") "Experiência académica e profissional"
  #"Criação do Projeto (Surgimento da ideia e data/ano de criação)"
```
gera o XML que se segue:
```XML
<perguntas>
    <p metafield="Nome" op="7" value="José João">Experiência académica e profissional</p>
    <p>Criação do Projeto (Surgimento da ideia e data/ano de criação)</p>
    ...
```
