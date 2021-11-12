#INCLUDE "PROTHEUS.CH"
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'FWLIBVERSION.CH'

/*/{Protheus.doc} Ocurrences
Classe de ocorr�ncias para a API REST. A classe herda de FWAdapterBaseV2 
@type class
@version 1.0
@author Felipe Naganava
@since 12/11/2021
/*/
CLASS Ocurrences FROM FWAdapterBaseV2
	METHOD New()
	METHOD GetList()
	METHOD GetOcurrence(cId)

EndClass

/*/{Protheus.doc} Ocurrences::New
M�todo construtor da classe Ocurrences
@type method
@version 1.0
@author Felipe Naganava
@since 12/11/2021
@param cVerb, character, PUT, POST, GET ou DELETE
/*/
Method New( cVerb ) CLASS Ocurrences
	_Super:New( cVerb, .T. )
Return

/*/{Protheus.doc} Ocurrences::GetList
M�todo para buscar a lista de ocorr�ncias
@type method
@version 1.0
@author Felipe Naganava
@since 12/11/2021
/*/
Method GetList() CLASS Ocurrences
    Local aArea     := FwGetArea()
    Local cQuery    := ''
    Local cWhere    := ''

    ::AddMapFields('FILIAL' ,'X5_FILIAL' 	,.T.,.F.,{'X5_FILIAL'   ,'C',TamSX3('X5_FILIAL')[1]		,0})
    ::AddMapFields('TABELA' ,'X5_TABELA' 	,.T.,.F.,{'X5_TABELA'   ,'C',TamSX3('X5_TABELA')[1]		,0})
    ::AddMapFields('CHAVE'  ,'X5_CHAVE'  	,.T.,.F.,{'X5_CHAVE'    ,'C',TamSX3('X5_CHAVE')[1]		,0})
    ::AddMapFields('DESCRI' ,'X5_DESCRI' 	,.T.,.F.,{'X5_DESCRI'   ,'C',TamSX3('X5_DESCRI')[1]		,0})
    ::AddMapFields('DESCSPA','X5_DESCSPA'	,.T.,.F.,{'X5_DESCSPA'  ,'C',TamSX3('X5_DESCSPA')[1]	,0})
    ::AddMapFields('DESCENG','X5_DESCENG'	,.T.,.F.,{'X5_DESCENG'  ,'C',TamSX3('X5_DESCENG')[1]	,0})
	If (FwLibVersion()) >= '20200727' //S� � poss�vel trazer o recno apartir da lib 20200727
		::AddMapFields('SX5RECNO'	,'SX5RECNO'		,.T.,.F.,{'SX5RECNO'	,'N',15							,0 },'SX5.R_E_C_N_O_' )
	EndIf
    
	cQuery := getQuery()
	::SetQuery(cQuery)

    cWhere := " d_e_l_e_t_ = ' ' AND x5_tabela = 'T9' AND x5_filial = ' '"
	::SetWhere(cWhere)

    ::SetOrder( "X5_CHAVE" )

	If ::Execute() 
		::FillGetResponse()
	EndIf
	FwrestArea(aArea)
Return

/*/{Protheus.doc} Ocurrences::GetOcurrence
M�todo para buscar uma ocorr�ncia em especifico
@type method
@version 1.0
@author Felipe Naganava
@since 12/11/2021
@param cId, character, C�digo recno do registro
/*/
Method GetOcurrence(cId) CLASS Ocurrences
    Local aArea     := FwGetArea()
    Local cQuery    := ''
    Local cWhere    := ''

    ::AddMapFields('FILIAL' ,'X5_FILIAL' 	,.T.,.F.,{'X5_FILIAL'   ,'C',TamSX3('X5_FILIAL')[1]		,0})
    ::AddMapFields('TABELA' ,'X5_TABELA' 	,.T.,.F.,{'X5_TABELA'   ,'C',TamSX3('X5_TABELA')[1]		,0})
    ::AddMapFields('CHAVE'  ,'X5_CHAVE'  	,.T.,.F.,{'X5_CHAVE'    ,'C',TamSX3('X5_CHAVE')[1]		,0})
    ::AddMapFields('DESCRI' ,'X5_DESCRI' 	,.T.,.F.,{'X5_DESCRI'   ,'C',TamSX3('X5_DESCRI')[1]		,0})
    ::AddMapFields('DESCSPA','X5_DESCSPA'	,.T.,.F.,{'X5_DESCSPA'  ,'C',TamSX3('X5_DESCSPA')[1]	,0})
    ::AddMapFields('DESCENG','X5_DESCENG'	,.T.,.F.,{'X5_DESCENG'  ,'C',TamSX3('X5_DESCENG')[1]	,0})
	If (FwLibVersion()) >= '20200727' //S� � poss�vel trazer o recno apartir da lib 20200727
		::AddMapFields('SX5RECNO'	,'SX5RECNO'		,.T.,.F.,{'SX5RECNO'	,'N',15							,0 },'SX5.R_E_C_N_O_' )
	EndIf
    
	cQuery := getQuery()
	::SetQuery(cQuery)

    cWhere := " d_e_l_e_t_ = ' ' AND x5_tabela = 'T9' AND x5_filial = ' ' AND SX5.R_E_C_N_O_ = '"+cId+"'"
	::SetWhere(cWhere)

    ::SetOrder( "X5_CHAVE" )

	If ::Execute() 
		::FillGetResponse()
	EndIf
	FwrestArea(aArea)
Return

/*/{Protheus.doc} getQuery
Fun��o utilizada para criar a query que busca os registros no banco de dados
@type function
@version 1.0
@author Felipe Naganava
@since 12/11/2021
@return character, Query
/*/
Static Function getQuery()
    Local cQuery := ""
    cQuery := "SELECT "
    cQuery += "    #QueryFields# "
    cQuery += "FROM "
    cQuery += "    "+RetSqlName('SX5')+" SX5 "
    cQuery += "WHERE "
    cQuery += "    #QueryWhere#"
Return cQuery
