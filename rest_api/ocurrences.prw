#INCLUDE "PROTHEUS.CH"
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'FWLIBVERSION.CH'

/*/{Protheus.doc} Ocurrences
Classe de ocorrências para a API REST. A classe herda de FWAdapterBaseV2 
@type class
@version 1.0
@author Felipe Naganava
@since 12/11/2021
/*/
CLASS Ocurrences FROM FWAdapterBaseV2
	METHOD New()
	METHOD GetList()
	METHOD GetOcurrence(cId)
    METHOD Create(cTabela,cChave,cDescri,cDescSpa,cDescEng,oResponse)

EndClass

/*/{Protheus.doc} Ocurrences::New
Método construtor da classe Ocurrences
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
Método para buscar a lista de ocorrências
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
	If (FwLibVersion()) >= '20200727' //Só é possível trazer o recno apartir da lib 20200727
		::AddMapFields('SX5RECNO'	,'SX5RECNO'		,.T.,.F.,{'SX5RECNO'	,'N',15							,0 },'SX5.R_E_C_N_O_' )
	EndIf
    
	cQuery := getQuery()
	::SetQuery(cQuery)

    cWhere := " d_e_l_e_t_ = ' ' AND x5_tabela = 'ZZ' AND x5_filial = 'LG01'"
	::SetWhere(cWhere)

    ::SetOrder( "X5_CHAVE" )

	If ::Execute() 
		::FillGetResponse()
	EndIf
	FwrestArea(aArea)
Return

/*/{Protheus.doc} Ocurrences::GetOcurrence
Método para buscar uma ocorrência em especifico
@type method
@version 1.0
@author Felipe Naganava
@since 12/11/2021
@param cId, character, Código recno do registro
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
	If (FwLibVersion()) >= '20200727' //Só é possível trazer o recno apartir da lib 20200727
		::AddMapFields('SX5RECNO'	,'SX5RECNO'		,.T.,.F.,{'SX5RECNO'	,'N',15							,0 },'SX5.R_E_C_N_O_' )
	EndIf
    
	cQuery := getQuery()
	::SetQuery(cQuery)

    cWhere := " d_e_l_e_t_ = ' ' AND x5_tabela = 'ZZ' AND x5_filial = 'LG01' AND SX5.R_E_C_N_O_ = '"+cId+"'"
	::SetWhere(cWhere)

    ::SetOrder( "X5_CHAVE" )

	If ::Execute() 
		::FillGetResponse()
	EndIf
	FwrestArea(aArea)
Return

/*/{Protheus.doc} Ocurrences::Create
Método para criar uma nova ocorrência no Protheus
@type method
@version 1.0
@author Felipe Naganava
@since 13/11/2021
@param cChave, character, chave
@param cDescri, character, descrição
@param cDescSpa, character, descrição em espanhol
@param cDescEng, character, descrição em inglês
@param oResponse, object, objeto json para resposta do rest (Passar paramêtro como referencia "@")
/*/
Method Create(cChave,cDescri,cDescSpa,cDescEng,oResponse) CLASS Ocurrences
	If (cChave == Nil .OR. cDescri == Nil .OR. cDescSpa == Nil .OR. cDescEng == Nil)
		::lOk := .F.
		oResponse["error"] := "body_invalido"
        oResponse["description"] := "Forneça as propriedades 'chave', 'descri', 'descSpa' e descEng no body"
    Else
		DBSelectArea('SX5')
		DBSetOrder(1) //X5_FILIAL, X5_TABELA, X5_CHAVE, R_E_C_N_O_, D_E_L_E_T_
		If DBSeek('LG01'+'ZZ'+cChave)
			oResponse["error"] := "chave_ja_existe"
        	oResponse["description"] := "A chave informada já existe"
		Else
			RecLock('SX5', .T.)
				X5_FILIAL   := 'LG01'
				X5_TABELA   := 'ZZ'
				X5_CHAVE    := cChave
				X5_DESCRI   := cDescri
				X5_DESCSPA  := cDescSpa
				X5_DESCENG  := cDescEng
			SX5->(MsUnlock())
			oResponse["filial"]		:= SX5->X5_FILIAL
			oResponse["tabela"]		:= SX5->X5_TABELA
			oResponse["chave"]		:= SX5->X5_CHAVE
			oResponse["descri"]		:= SX5->X5_DESCRI
			oResponse["descSpa"]	:= SX5->X5_DESCSPA
			oResponse["descEng"] 	:= SX5->X5_DESCENG
			oResponse["recno"]		:= SX5->(recno())
			::lOk := .T.
		EndIf
    EndIf
	
Return

/*/{Protheus.doc} getQuery
Função utilizada para criar a query que busca os registros no banco de dados
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
