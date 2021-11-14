# LIGUE ADVPL developer test
Teste para seleção de desenvolvedores LIGUE

## API REST
### GET
> **O campo recno só será retornado caso a LIB seja superior a 20200727**

	GET /ocurrences
Irá retornar uma lista com todos as ocorrências registradas no Protheus.
> Pode ser adicionado os parâmetros page e pageSize para selecionar quantos registros por página deseja retornar.
/ocurrences?page=2&pageSize=10
Irá retornar a segunda página com 10 registros.

	GET /ocurrences/{recno}
Irá retornar os dados da ocorrência com o recno selecionado.

### POST
	POST /ocurrences
Adiciona uma nova ocorrência no Protheus
> O body deve conter as propriedades "chave","descri","descSpa" e "descEng". Outras propriedades serão ignoradas.

### PUT
	PUT /ocurrences/{recno}
Atualiza um registro no Protheus
> O body deve conter ao menos uma das propriedades "descri","descSpa" ou "descEng". Não é possível alterar a chave, recno, tabela ou filial.

### DELETE
	DELETE /ocurrences/{recno}
Deleta um registro no Protheus
