# quantia-por-extenso-SQL

Feito no Oracle 10g, usando apenas comandos de DML. O output é feito em português do Brasil (PT-BR).

Há equivalentes nativos do Oracle para numerais em geral, mas apenas em inglês, até a data de desenvolvimento deste código.

Tentei obedecer uma maneira brasileira de falar, inclusive a escolha de conectores, como vírgula ou conjunção "e", além da preposição "de" em raros casos (ex: um milhão "de" reais).

O valor no gerador precisa ser consultado num SELECT. Pode-se também fazer um SELECT que retorne mais linhas, para avaliar mais valores na mesma query. Pode-se também trocar o valor literal por uma bind variable, se for executado num ambiente compatível.

Como isto não é PL/SQL, não consegui pensar numa maneira de simular uma passagem de argumento. Para incluir o valor em outra query seria necessário um join, e talvez só seja possível por crossjoin (algo que eu recomendaria apenas para consultas de uma linha só, como por exemplo para exibição de um form preenchido); ou então duplicar lógica da consulta principal no GERADOR, e selecionar as chaves correspondentes junto para fazer outro tipo de join.
