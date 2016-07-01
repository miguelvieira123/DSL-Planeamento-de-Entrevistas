# DSL-Planeamento-de-Entrevistas


##Códigos para condições nas tags de perguntas

|codigo |   OP|
|-------|------|
|1   |   == |
|2   |   != |
|3   |   <  |
|4   |   >  |
|5   |   <= |
|6   |   >= |
|7   |   regex|

###Exemplo de Aplicação
O excerto de uma frase válida,
```
perguntas:
  #("JJ" regex "Nome") "Experiência académica e profissional"
  #"Criação do Projeto (Surgimento da ideia e data/ano de criação)"
```
gera o XML que se segue:
```XML
<perguntas>
    <p metafield="Nome" op="7" value="JJ">Experiência académica e profissional</p>
    <p>Criação do Projeto (Surgimento da ideia e data/ano de criação)</p>
    ...
```
