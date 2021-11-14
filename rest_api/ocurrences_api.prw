#INCLUDE "PROTHEUS.CH"
#INCLUDE "RESTFUL.CH"

#xtranslate @{Route} => Do Case
#xtranslate @{When <path>} => Case NGIsRoute( ::aURLParms, <path> )
#xtranslate @{Default} => Otherwise
#xtranslate @{EndRoute} => EndCase

/*/{Protheus.doc} ocurrences
WSRESTFUL de ocorr�ncias
@type WSRESTFUL
@version 1.0
@author Felipe Naganava
@since 12/11/2021
/*/
WSRESTFUL ocurrences DESCRIPTION "WebService REST ocurrences API" FORMAT "application/json"
	WSDATA page AS INTEGER OPTIONAL
	WSDATA pageSize AS INTEGER OPTIONAL

	WSMETHOD GET ocurrences;
		DESCRIPTION "Retorna dados referente a ocorr�ncias";
		WSSYNTAX "/{method}";
		PRODUCES APPLICATION_JSON

	WSMETHOD POST ocurrences;
		DESCRIPTION "Cria uma nova ocorr�ncia no Protheus";
		WSSYNTAX "/{method}";
		PRODUCES APPLICATION_JSON
END WSRESTFUL

/*/{Protheus.doc} ocurrences
M�todo GET, respons�vel pelo maepamento do m�todo
@type WSMETHOD
@version 1.0
@author Felipe Naganava
@since 12/11/2021
@return logical, .T. caso a requisi��o seja um sucesso, .F. se der algum erro 
/*/
WSMETHOD GET ocurrences QUERYPARAM page,pageSize WSREST ocurrences
	Local lRet := .T.

	@{Route}
        @{When '/'}
			lRet := getList(self)
		@{When '/{id}'}
			lRet := getOcurrence(self)
		@{Default}
            SetRestFault(400,"Bad Request")
			lRet := .F.
	@{EndRoute}
Return lRet

/*/{Protheus.doc} ocurrences
M�todo POST, respons�vel pelo maepamento do m�todo
@type WSMETHOD
@version 1.0
@author Felipe Naganava
@since 13/11/2021
@return logical, .T. caso a requisi��o seja um sucesso, .F. se der algum erro 
/*/
WSMETHOD POST ocurrences WSREST ocurrences
	Local lRet

	@{Route}
        @{When '/'}
			lRet := postOcurrence(self)	
		@{Default}
            SetRestFault(400,"Bad Request")
			lRet := .F.
	@{EndRoute}
Return lRet

/*/{Protheus.doc} getList
Fun��o que faz o tratamento da requisi��o de lista de ocorr�ncias
@type function
@version 1.0
@author Felipe Naganava
@since 12/11/2021
@param oWS, object, objeto de requisi��o
@return logical, .T. caso a requisi��o seja um sucesso, .F. se der algum erro 
/*/
Static Function getList(oWS)
	Local lRet  := .T.
	Local oOcurrences := nil

	DEFAULT oWS:page		:= 1 
	DEFAULT oWS:pageSize	:= 3 

	oOcurrences := ocurrences():new( 'GET' )
  
	oOcurrences:setPage(oWS:page)
	oOcurrences:setPageSize(oWS:pageSize)
	oOcurrences:GetList()

	If oOcurrences:lOk
		oWS:SetResponse(oOcurrences:getJSONResponse())
	Else
		SetRestFault(oOcurrences:GetCode(),oOcurrences:GetMessage())
		lRet := .F.
	EndIf
	
	oOcurrences:DeActivate()
	oOcurrences := nil
Return lRet

/*/{Protheus.doc} getOcurrence
Fun��o quer faz o tratamento da requisi��o de uma ocorr�ncia por seu recno
@type function
@version 1.0
@author Felipe Naganava
@since 12/11/2021
@param oWS, object,  objeto de requisi��o
@return logical, .T. caso a requisi��o seja um sucesso, .F. se der algum erro 
/*/
Static Function getOcurrence(oWS)
	Local lRet  := .T.
	Local oOcurrence := nil

	oOcurrence := ocurrences():new( 'GET' )
  	oOcurrence:GetOcurrence(oWS:aURLParms[1])

	If oOcurrence:lOk
		oWS:SetResponse(oOcurrence:getJSONResponse())
	Else
		SetRestFault(oOcurrence:GetCode(),oOcurrence:GetMessage())
		lRet := .F.
	EndIf
	//faz a desaloca��o de objetos e arrays utilizados
	oOcurrence:DeActivate()
	oOcurrence := nil
Return lRet

/*/{Protheus.doc} postOcurrence
Fun��o para tratamento do m�todo post
@type function
@version 1.0
@author Felipe Naganava
@since 13/11/2021
@param oWS, object, objeto de requisi��o
@return logical, .T. caso a requisi��o seja um sucesso, .F. se der algum erro 
/*/
Static Function postOcurrence(oWS)	
	Local lRet			:= .T.
	Local oOcurrence	:= nil
	Local oResponse		:= JsonObject():New()
	Local oBody			:= JsonObject():New()

	oBody := JsonObject():New()
    oBody:FromJson(oWs:GetContent())

	cChave		:= oBody["chave"]
	cDescri		:= oBody["descri"]
	cDescSpa	:= oBody["descSpa"]
	cDescEng	:= oBody["descEng"]

	oOcurrence := ocurrences():new('POST')
	oOcurrence:Create(cChave,cDescri,cDescSpa,cDescEng,@oResponse)

	If oOcurrence:lOk
		oWS:SetResponse(oResponse:toJson())
	Else
		SetRestFault(400,oResponse:toJson())
		lRet := .F.
	EndIf
Return lRet
