-- Dentro de gerador, digite qualquer quantia monetária entre 0 centavos até 9999999.99 (9 milhões, 999 mil, 999 e 99 centavos)
WITH
GERADOR AS (
    SELECT 999999.99 AS VALOR FROM DUAL
),
FORMATADOR AS (
    SELECT
      SUBSTR(LPAD(TO_CHAR(GERADOR.VALOR, '9999990.00'), 20), -10, 10) AS V,
      LENGTH(LTRIM(TO_CHAR(GERADOR.VALOR, '9999990.00'))) AS COUNT
    FROM GERADOR
),
UNIDADES_EXTENSO(ID, N, E) AS (
    SELECT 1, '1', 'um' FROM DUAL
    UNION ALL
    SELECT
    	ID+1, TO_CHAR(ID+1),
        CASE ID+1
        	WHEN 1 THEN 'um'
            WHEN 2 THEN 'dois'
            WHEN 3 THEN 'três'
            WHEN 4 THEN 'quatro'
            WHEN 5 THEN 'cinco'
            WHEN 6 THEN 'seis'
            WHEN 7 THEN 'sete'
            WHEN 8 THEN 'oito'
            WHEN 9 THEN 'nove'
            WHEN 10 THEN 'dez'
            WHEN 11 THEN 'onze'
            WHEN 12 THEN 'doze'
            WHEN 13 THEN 'treze'
            WHEN 14 THEN 'catorze'
            WHEN 15 THEN 'quinze'
            WHEN 16 THEN 'dezesseis'
            WHEN 17 THEN 'dezessete'
            WHEN 18 THEN 'dezoito'
            WHEN 19 THEN 'dezenove'
        END
    FROM UNIDADES_EXTENSO
    WHERE ID+1 <= 19
),
DEZENAS_EXTENSO(ID, N, E) AS (
    SELECT 2, '2', 'vinte' FROM DUAL
    UNION ALL
    SELECT
    	ID+1, TO_CHAR(ID+1),
        CASE ID+1
            WHEN 2 THEN 'vinte'
            WHEN 3 THEN 'trinta'
            WHEN 4 THEN 'quarenta'
            WHEN 5 THEN 'cinquenta'
            WHEN 6 THEN 'sessenta'
            WHEN 7 THEN 'setenta'
            WHEN 8 THEN 'oitenta'
            WHEN 9 THEN 'noventa'
        END
    FROM DEZENAS_EXTENSO
    WHERE ID+1 <= 9
),
CENTENAS_EXTENSO(ID, N, E) AS (
    SELECT 2, '2', 'duzentos' FROM DUAL
    UNION ALL
    SELECT
    	ID+1, TO_CHAR(ID+1),
        CASE ID+1
            WHEN 2 THEN 'duzentos'
            WHEN 3 THEN 'trezentos'
            WHEN 4 THEN 'quatrocentos'
            WHEN 5 THEN 'quinhentos'
            WHEN 6 THEN 'seiscentos'
            WHEN 7 THEN 'setecentos'
            WHEN 8 THEN 'oitocentos'
            WHEN 9 THEN 'novecentos'
        END
    FROM CENTENAS_EXTENSO
    WHERE ID+1 <= 9
),
MONETARIO_EXTENSO AS (
    SELECT
	TRIM( REGEXP_REPLACE(REGEXP_REPLACE( REGEXP_REPLACE(
	    CASE																																		
	      WHEN QUANTIA.COUNT < 10 THEN ''
	      ELSE MILHAO.E
	    END || CASE WHEN MILHAO.ID = 1 THEN ' milhão ' WHEN MILHAO.ID IS NOT NULL THEN ' milhões ' END
	    ||
		CASE WHEN QUANTIA.COUNT=10 AND TO_NUMBER(LTRIM(SUBSTR(QUANTIA.V, 2, 6))) = 0 THEN ' de ' ELSE '' END													
	    ||
	    CASE WHEN QUANTIA.COUNT=10 AND 0 IN (TO_NUMBER(LTRIM(SUBSTR(QUANTIA.V, 2, 3))), TO_NUMBER(LTRIM(SUBSTR(QUANTIA.V, 5, 3)))) AND TO_NUMBER(LTRIM(SUBSTR(QUANTIA.V, 2, 6))) <> 0 THEN ' e '
	    	ELSE CASE WHEN QUANTIA.COUNT=10 AND TO_NUMBER(LTRIM(SUBSTR(QUANTIA.V, 2, 6))) <> 0 THEN ',' ELSE '' END END
	    ||
	    CASE																																		
	      WHEN QUANTIA.COUNT < 9 THEN ''
	      ELSE CENTENAS_DE_MILHARES.E
	    END || CASE WHEN SUBSTR(QUANTIA.V,2,1) = '1' THEN CASE WHEN TO_NUMBER(LTRIM(SUBSTR(QUANTIA.V, 3, 2))) = 0 THEN ' cem ' ELSE ' cento ' END ELSE '' END
	    ||
	    CASE																																		
	      WHEN QUANTIA.COUNT >= 9 THEN
	        CASE
	          WHEN TO_NUMBER(LTRIM(SUBSTR(QUANTIA.V, 3, 2))) = 0 THEN ''
	          ELSE ' e '
	        END
	      ELSE ''
	    END
	    ||
		COALESCE (DEZ_E_UNI_DE_MILHARES.E, DEZENAS_DE_MILHARES.E, '')																				
	    ||
	    CASE																																		
	      WHEN DEZ_E_UNI_DE_MILHARES.E IS NULL THEN
	    	CASE WHEN DEZENAS_DE_MILHARES.E IS NULL THEN '' ELSE ' e ' END
	      ELSE ''
	    END
	    ||
	    CASE WHEN DEZ_E_UNI_DE_MILHARES.E IS NULL THEN COALESCE(UNIDADES_DE_MILHARES.E, '') ELSE '' END												
	    || CASE WHEN COALESCE(TO_NUMBER(LTRIM(SUBSTR(QUANTIA.V, 2, 3))), 0) = 0 THEN '' ELSE ' mil ' END
	    ||
	    CASE																																		
	      WHEN QUANTIA.COUNT > 6 THEN
	      	CASE WHEN SUBSTR(QUANTIA.V, 5, 1) = '0' THEN
	          CASE WHEN COALESCE(TO_NUMBER(LTRIM(SUBSTR(QUANTIA.V, 6, 2))), 0) = 0 THEN '' ELSE ' e ' END
	        ELSE ', '
	        END
	      ELSE ''
	    END
	    ||
	    CENTENAS.E																																	
		||
	    CASE WHEN SUBSTR(QUANTIA.V,5,1) = '1' THEN CASE WHEN TO_NUMBER(LTRIM(SUBSTR(QUANTIA.V, 6, 2))) = 0 THEN ' cem ' ELSE ' cento e ' END ELSE '' END
	    ||
	    CASE WHEN SUBSTR(QUANTIA.V, 5, 1) NOT IN ('1', '0', ' ') THEN CASE WHEN TO_NUMBER(LTRIM(SUBSTR(QUANTIA.V, 6, 2))) <> 0 THEN ' e ' ELSE '' END ELSE '' END
	    ||
		COALESCE( DEZ_E_UNIDADES.E, DEZENAS.E, '' )																									
	    ||
	    CASE																																		
	      WHEN DEZ_E_UNIDADES.E IS NULL THEN
	      	CASE WHEN DEZENAS.E IS NOT NULL AND UNIDADES.E IS NOT NULL THEN ' e ' ELSE '' END
	      ELSE ''
	    END
	    ||
	    CASE WHEN DEZ_E_UNIDADES.E IS NULL THEN UNIDADES.E END																						
	    ||
	    CASE
	      WHEN QUANTIA.COUNT = 4 AND UNIDADES.ID = 1 THEN ' real '
	      ELSE CASE WHEN TO_NUMBER(LTRIM(SUBSTR(QUANTIA.V,1,7))) <> 0 THEN ' reais ' END
	    END
	    ||
	    CASE WHEN TO_NUMBER(LTRIM(SUBSTR(QUANTIA.V,1,7))) <> 0 AND TO_NUMBER(LTRIM(SUBSTR(QUANTIA.V,9,2))) <> 0 THEN ' e ' ELSE '' END					
	    ||
	    COALESCE( C_DEZ_E_UNIDADES.E, C_DEZENAS.E, '' )																								
	    ||
	    CASE WHEN C_DEZ_E_UNIDADES.E IS NULL AND C_DEZENAS.E IS NOT NULL AND C_UNIDADES.E IS NOT NULL THEN ' e ' END								
	    ||
	    CASE WHEN C_DEZ_E_UNIDADES.E IS NULL THEN C_UNIDADES.E END																					
	    ||
	    CASE TO_NUMBER(LTRIM(SUBSTR(QUANTIA.V,9,2)))
	      WHEN 0 THEN ''
	      WHEN 1 THEN ' centavo'
	      ELSE ' centavos'
	    END
	    , '[[:space:]]+', ' '), '[[:space:]],', ',' ), 'e e', 'e' ) 
	) AS QUANTIA_EXTENSO
	
    FROM
	FORMATADOR QUANTIA
	LEFT JOIN UNIDADES_EXTENSO MILHAO ON SUBSTR(QUANTIA.V, 1, 1) = MILHAO.N
	LEFT JOIN CENTENAS_EXTENSO CENTENAS_DE_MILHARES ON SUBSTR(QUANTIA.V, 2, 1) = CENTENAS_DE_MILHARES.N
	LEFT JOIN UNIDADES_EXTENSO DEZ_E_UNI_DE_MILHARES ON SUBSTR(QUANTIA.V, 3, 2) = DEZ_E_UNI_DE_MILHARES.N
	LEFT JOIN DEZENAS_EXTENSO DEZENAS_DE_MILHARES ON SUBSTR(QUANTIA.V, 3, 1) = DEZENAS_DE_MILHARES.N
	LEFT JOIN UNIDADES_EXTENSO UNIDADES_DE_MILHARES ON SUBSTR(QUANTIA.V, 4, 1) = UNIDADES_DE_MILHARES.N
	LEFT JOIN CENTENAS_EXTENSO CENTENAS ON SUBSTR(QUANTIA.V, 5, 1) = CENTENAS.N
	LEFT JOIN DEZENAS_EXTENSO DEZENAS ON SUBSTR(QUANTIA.V, 6, 1) = DEZENAS.N
	LEFT JOIN UNIDADES_EXTENSO DEZ_E_UNIDADES ON SUBSTR(QUANTIA.V, 6, 2) = DEZ_E_UNIDADES.N
	LEFT JOIN UNIDADES_EXTENSO UNIDADES ON SUBSTR(QUANTIA.V, 7, 1) = UNIDADES.N
	LEFT JOIN DEZENAS_EXTENSO C_DEZENAS ON SUBSTR(QUANTIA.V, 9, 1) = C_DEZENAS.N
	LEFT JOIN UNIDADES_EXTENSO C_DEZ_E_UNIDADES ON SUBSTR(QUANTIA.V, 9, 2) = C_DEZ_E_UNIDADES.N
	LEFT JOIN UNIDADES_EXTENSO C_UNIDADES ON SUBSTR(QUANTIA.V, 10, 1) = C_UNIDADES.N
)

SELECT * FROM MONETARIO_EXTENSO
