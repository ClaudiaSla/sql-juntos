--******TABLAS A USAR************
select * from sitc.tcorte_hogar ;
select*from sitc.tcorte_CAB
order by id_corte desc;
describe sitc.tcorte_hogar;

--########################  WORD  #########################

--********** 1. CUADRO GENERAL REGION [NOMBRE LA REGION]*************

--********************************************************** 1.1 # USUARIOS EN LA PROVINCIA *************************

SELECT
    juntos.f_departamento_desc(tc.c_depa) AS DEPARTAMENTO,
    juntos.f_provincia_desc(tc.c_depa, tc.c_prov) AS PROVINCIA,
    --juntos.f_distrito_desc(tc.c_depa, tc.c_prov, tc.c_dist) AS DISTRITO,
    --juntos.f_cpoblado_desc(tc.c_depa, tc.c_prov, tc.c_dist, tc.c_poblado) AS CCPP
    COUNT(*) AS CANTIDAD
FROM sitc.tcorte_hogar tc
WHERE tc.c_depa = '21' 
  AND tc.id_corte = '324' 
  AND tc.estado = '1'
GROUP BY 
    juntos.f_departamento_desc(tc.c_depa),
    juntos.f_provincia_desc(tc.c_depa, tc.c_prov)
    --juntos.f_distrito_desc(tc.c_depa, tc.c_prov, tc.c_dist)
    --juntos.f_cpoblado_desc(tc.c_depa, tc.c_prov, tc.c_dist, tc.c_poblado)
ORDER BY PROVINCIA; --,DISTRITO,CCPP

--********************************************************** 1.2 # NUEVOS USUARIOS EN LA PROVINCIA *************************
SELECT
    juntos.f_departamento_desc(tc.c_depa) AS DEPARTAMENTO,
    juntos.f_provincia_desc(tc.c_depa, tc.c_prov) AS PROVINCIA,
    --juntos.f_distrito_desc(tc.c_depa, tc.c_prov, tc.c_dist) AS DISTRITO,
    --juntos.f_cpoblado_desc(tc.c_depa, tc.c_prov, tc.c_dist, tc.c_poblado) AS CCPP
    COUNT(*) AS CANTIDAD
FROM sitc.tcorte_hogar tc
WHERE tc.c_depa = '21' 
  AND tc.id_corte = '324' 
  AND tc.estado = '1'
  AND tc.tipo_padron = '1'
GROUP BY 
    juntos.f_departamento_desc(tc.c_depa),
    juntos.f_provincia_desc(tc.c_depa, tc.c_prov)
    --juntos.f_distrito_desc(tc.c_depa, tc.c_prov, tc.c_dist)
    --juntos.f_cpoblado_desc(tc.c_depa, tc.c_prov, tc.c_dist, tc.c_poblado)
ORDER BY PROVINCIA; --,DISTRITO,CCPP


--********************************************************** 1.3  #USUARIOS POR VENCER (REGION/PROVINCIA) *************************


SELECT
juntos.f_departamento_desc(tc.c_depa) AS DEPARTAMENTO,
    juntos.f_provincia_desc(tc.c_depa, tc.c_prov) AS PROVINCIA,
    --juntos.f_distrito_desc(tc.c_depa, tc.c_prov, tc.c_dist) AS DISTRITO,
    --juntos.f_cpoblado_desc(tc.c_depa, tc.c_prov, tc.c_dist, tc.c_poblado) AS CCPP
    COUNT(*) AS CANTIDAD
FROM SITC.TCORTE_HOGAR TC
WHERE  trunc(TC.HOGAR_CSE_VIGENCIA_FIN) < TO_DATE('30/06/2026','DD/MM/YYYY') AND
 tc.c_depa = '21' AND tc.id_corte = '324' AND tc.estado = '1'
GROUP BY 
    juntos.f_departamento_desc(tc.c_depa),
    juntos.f_provincia_desc(tc.c_depa, tc.c_prov)
   ORDER BY PROVINCIA ;



--********** 2. LOGROS Y METAS **************

--********************************************************** 2.1  [PREGUNTAR A JESI] *************************

--********************************************************** 2.2  [2DO CHECK] *************************

/* EJEMPLO: 
En el bimestre VI-2025, se incorporan al Programa Juntos 672 hogares (410 nuevos afiliados y 262 reincorporados), 
haciendo un total de 3,880 hogares (2,354 nuevos afiliados y 1,526 reincorporados) del departamento de Puno que se incorporan al Programa Juntos en el año 2025.)*/


--2.2.1 En el bimestre VI-2025, se incorporan al Programa Juntos 672 hogares (410 nuevos afiliados y 262 reincorporados)

SELECT
    juntos.f_departamento_desc(tc.c_depa) AS DEPARTAMENTO,
    --juntos.f_provincia_desc(tc.c_depa, tc.c_prov) AS PROVINCIA,
    'BIMESTRE VI-2025' AS PERIODO,
    COUNT(CASE WHEN tc.tipo_padron = '1' THEN 1 END) AS NUEVOS_AFILIADOS,
    COUNT(CASE WHEN tc.tipo_padron = '2' THEN 1 END) AS REINCORPORADOS,
    COUNT(*) AS TOTAL_GENERAL
FROM sitc.tcorte_hogar tc
WHERE tc.c_depa = '21' 
  AND tc.id_corte = '324' 
  AND tc.estado = '1'
  AND tc.tipo_padron IN ('1', '2')
GROUP BY 
    juntos.f_departamento_desc(tc.c_depa);


-- total de 3,880 hogares (2,354 nuevos afiliados y 1,526 reincorporados) del departamento de Puno que se incorporan al Programa Juntos en el año 2025.
-- 2.1.2 TOTAL DE HOGARES [CANTIDAD] ('X' NUEVOS AFILIADOS , 'Y' REINCORPORADOS) DEL DEPARTAMENTO DE [NDEPA] QUE SE INCORPORAN AL PROGRAMA JUNTOS EN EL AÑO 2025. (cortes del 319 - 324)

SELECT
    juntos.f_departamento_desc(tc.c_depa) AS DEPARTAMENTO,
    'TOTAL AÑO 2025' AS PERIODO,
    COUNT(CASE WHEN tc.tipo_padron = '1' THEN 1 END) AS TOTAL_HOGARES_AFILIADOS,
    COUNT(CASE WHEN tc.tipo_padron = '2' THEN 1 END) AS TOTAL_REINCORPORADOS,
    COUNT(*) AS TOTAL_GENERAL
FROM sitc.tcorte_hogar tc
WHERE tc.c_depa = '21' 
  AND tc.id_corte IN ('319', '320', '321', '322', '323', '324')
  AND tc.estado = '1'
  AND tc.tipo_padron IN ('1', '2')
GROUP BY 
    juntos.f_departamento_desc(tc.c_depa);
    
--********************************************************** 2.3  [3ER CHECK] *************************

WITH DATA_DETALLE AS (
      SELECT 
          h.ID_CORTE,
          h.ID_CORTE_HOGAR,
          u.X_GESTANTE,
          u.PUERPERA,
          u.FLAG_VALIDA_GENERACION,
          u.N_EDADMESES,
          u.N_EDADANIO
      FROM SITC.TCORTE_HOGAR h
      JOIN SITC.TCORTE_HOGAR_USUARIO u ON u.ID_CORTE_HOGAR = h.ID_CORTE_HOGAR
      JOIN JUNTOS.TDISTRITO di ON di.C_DEPA = h.C_DEPA AND di.C_PROV = h.C_PROV AND di.C_DIST = h.C_DIST
      JOIN JUNTOS.TREGION r ON r.C_REGION = di.C_REGION
      WHERE h.ID_CORTE = 324      
        AND r.C_REGION = '16'      
        AND h.ESTADO = '1'
        AND u.ESTADO = '1'
        AND r.FLG_PROGRAMA = '1'
        AND h.TIPO_PADRON IN ('1','2','3') 
),
CONTEOS_PREVIOS AS (
    SELECT 
        'BIMESTRE VI - 2025' AS CORTE_BIMESTRE,
        COUNT(DISTINCT ID_CORTE_HOGAR) AS TOTAL_HOGARES_AFILIADOS,
        COUNT(*) AS TOTAL_MO,
        -- Calculamos los 4 primeros grupos
        SUM(CASE WHEN X_GESTANTE = '1' THEN 1 ELSE 0 END) AS GESTANTES,
        SUM(CASE WHEN PUERPERA = '1' AND (FLAG_VALIDA_GENERACION IN ('1', '3') OR FLAG_VALIDA_GENERACION IS NULL) THEN 1 ELSE 0 END) AS PUERPERAS,
        SUM(CASE WHEN N_EDADMESES < 36 THEN 1 ELSE 0 END) AS M_3_ANOS,
        SUM(CASE WHEN N_EDADANIO BETWEEN 3 AND 11 THEN 1 ELSE 0 END) AS N_3_11_ANOS
    FROM DATA_DETALLE
)
SELECT 
    CORTE_BIMESTRE,
    TOTAL_HOGARES_AFILIADOS,
    TOTAL_MO,
    GESTANTES AS TOTAL_GESTANTES,
    PUERPERAS AS TOTAL_PUERPERAS,
    M_3_ANOS AS MENORES_3_AÑOS,
    N_3_11_ANOS AS NIÑOS_3_A_11_AÑOS,
    -- El quinto grupo es estrictamente la resta aritmética
    (TOTAL_MO - (GESTANTES + PUERPERAS + M_3_ANOS + N_3_11_ANOS)) AS ADOLESCENTES_12_A_19_AÑOS
FROM CONTEOS_PREVIOS;
    
--********************************************************** 2.4  [4TO CHECK] *************************    

--CUADRO POR BIMESTRE - BUSCAR POR DEPARTAMENTO - ulimo bimestre

--LINK : https://www2.juntos.gob.pe/infojuntos/index.html 
    
    
--********************************************************** 2.5 [5TO CHECK] **************************        

--LINK: https://app.powerbi.com/view?r=eyJrIjoiNTZiMzhhYmItN2Q5NC00NTg4LTllNDAtMGI4NmRhMDAyYTE4IiwidCI6IjA4N2Y4ZmZkLTY5NzItNDc1MC04ZjlhLWMwZTQ4YjU2YmQyZiJ9

-- RUTA: TRANSFERENCIA PRIMERA INFANCIA (TPI) > HOGARES TPI EN PHA: 6 - BIM  > FILTRAR POR [DEPA] O LO QUE SE NECESITE (HOJA 2) - CANTIDAD CUADRO ROJO SUPERIOR DERECHO 


--********************************************************** 2.6 [6TO CHECK] ***************************  

-- MISMO LINK
-- RUTA: TRANSFERENCIA PRIMERA INFANCIA (TPI) > HOGARES TPI EN PHA: 6 - BIM  > FILTRAR POR [DEPA] O LO QUE SE NECESITE (HOJA 5) - CUADRO AZUL (MODALIDAD DE PAGO)


--########################  EXCEL  #########################

--1. EXCEL [DEPARTAMENTO] CSE VENCIDA O POR VENCER

--1.1 NOMINA CON DETALLE

SELECT
    juntos.f_region_desc(tc.c_region) AS UT,
    tc.c_depa || tc.c_prov || tc.c_dist AS UBIGEO,
    juntos.f_departamento_desc(tc.c_depa) AS DEPARTAMENTO,
    juntos.f_provincia_desc(tc.c_depa, tc.c_prov) AS PROVINCIA,
    juntos.f_distrito_desc(tc.c_depa, tc.c_prov, tc.c_dist) AS DISTRITO,
    juntos.f_cpoblado_desc(tc.c_depa, tc.c_prov, tc.c_dist, tc.c_poblado) AS CCPP,
    tc.DIRECCION,
    TC.CEL_TITULAR,
    tc.codigohogar,
    tc.x_dni as DNI,
    tc.x_nombres as NOMBRES,
    tc.X_APPATERNO as APPATERNO,
    tc.X_APMATERNO as APMATERNO,
    TC.cse,
    TC.HOGAR_CSE_VIGENCIA_FIN   
FROM SITC.TCORTE_HOGAR TC
WHERE trunc(TC.HOGAR_CSE_VIGENCIA_FIN) < TO_DATE('30/06/2026','DD/MM/YYYY') 
  AND tc.c_depa = '21' 
  AND tc.id_corte = '324' 
  AND tc.estado = '1'
ORDER BY 
    UBIGEO,
    PROVINCIA, 
    DISTRITO;
    
--1.2 NOMINA CANTIDAD (RESUMEN)
SELECT
    tc.c_depa || tc.c_prov || tc.c_dist AS UBIGEO,
    juntos.f_departamento_desc(tc.c_depa) AS DEPARTAMENTO,
    juntos.f_provincia_desc(tc.c_depa, tc.c_prov) AS PROVINCIA,
    juntos.f_distrito_desc(tc.c_depa, tc.c_prov, tc.c_dist) AS DISTRITO,
    COUNT(*) AS CANTIDAD_HOGARES
FROM SITC.TCORTE_HOGAR TC
WHERE trunc(TC.HOGAR_CSE_VIGENCIA_FIN) < TO_DATE('30/06/2026','DD/MM/YYYY') 
  AND tc.c_depa = '21' 
  AND tc.id_corte = '324' 
  AND tc.estado = '1'
GROUP BY 
   tc.c_depa || tc.c_prov || tc.c_dist,
    juntos.f_departamento_desc(tc.c_depa),
    juntos.f_provincia_desc(tc.c_depa, tc.c_prov),
    juntos.f_distrito_desc(tc.c_depa, tc.c_prov, tc.c_dist)
ORDER BY 
    UBIGEO,
    PROVINCIA, 
    DISTRITO;
    

--2. EXCEL 2 [DEPARTAMENTO] - HOGARES NUEVOS AFILIADOS_ PHA VI-2025
SELECT
    juntos.f_region_desc(tc.c_region) AS UT,
    tc.c_depa || tc.c_prov || tc.c_dist AS UBIGEO,
    juntos.f_departamento_desc(tc.c_depa) AS DEPARTAMENTO,
    juntos.f_provincia_desc(tc.c_depa, tc.c_prov) AS PROVINCIA,
    juntos.f_distrito_desc(tc.c_depa, tc.c_prov, tc.c_dist) AS DISTRITO,
    juntos.f_cpoblado_desc(tc.c_depa, tc.c_prov, tc.c_dist, tc.c_poblado) AS CENTRO_POBLADO,
    tc.DIRECCION,
    TC.CEL_TITULAR,
    tc.codigohogar,
    tc.x_dni as DNI,
    tc.x_nombres as NOMBRES,
    tc.X_APPATERNO as APPATERNO,
    tc.X_APMATERNO as APMATERNO,
    TC.cse,
    TC.HOGAR_CSE_VIGENCIA_FIN    
    
FROM sitc.tcorte_hogar tc
WHERE tc.c_depa = '21' 
  AND tc.id_corte = '324' 
  AND tc.estado = '1'  AND tc.tipo_padron='1'
  
ORDER BY 
    UBIGEO,
    PROVINCIA, 
    DISTRITO,
    CENTRO_POBLADO;




--########################  PPT   #########################

 SELECT
 count(CASE WHEN tc.CSE = 'PE' THEN 1 END) as CANTIDAD_HOGARES_PEXTREMO ,
 count(CASE WHEN tc.CSE = 'PNE' THEN 1 END) as CANTIDAD_HOGARES_POBRE 
 FROM SITC.TCORTE_HOGAR tc
 WHERE tc.C_DEPA = '08' AND tc.C_PROV='09' AND tc.C_DIST='14' AND tc.id_corte='324' and tc.estado='1';   --080914 (megandoni)

SELECT DISTINCT CSE FROM SITC.TCORTE_HOGAR WHERE ID_CORTE='321';


WITH DATA_DETALLE AS (
      
      SELECT 
          di.X_DIST AS DISTRITO,
          h.cse,
         -- H.HOGAR_TPI,
          h.ID_CORTE,
          h.TIPO_PADRON,
          h.ID_CORTE_HOGAR,
          u.X_GESTANTE,
          u.PUERPERA,
          u.FLAG_VALIDA_GENERACION,
          u.N_EDADMESES,
          u.N_EDADANIO
          
      FROM SITC.TCORTE_HOGAR h
      
      JOIN SITC.TCORTE_HOGAR_USUARIO u 
            ON u.ID_CORTE_HOGAR = h.ID_CORTE_HOGAR
            
      JOIN JUNTOS.TDISTRITO di 
            ON di.C_DEPA = h.C_DEPA 
                AND di.C_PROV = h.C_PROV 
                AND di.C_DIST = h.C_DIST
                
      JOIN JUNTOS.TREGION r 
            ON r.C_REGION = di.C_REGION
            
      WHERE h.ID_CORTE = 324   
        AND H.C_DEPA = '08'
        AND H.C_PROV = '09'
        AND DI.C_DIST = '14' 
        AND h.ESTADO = '1'
        AND u.ESTADO = '1'
        AND h.TIPO_PADRON IN ('1','2','3') 
  )
  
  SELECT 
      DISTRITO,
      'BIMESTRE VI - 2025' AS CORTE_BIMESTRE,
      -- 1. TOTALES GENERALES
      COUNT(DISTINCT ID_CORTE_HOGAR) AS TOTAL_HOGARES_AFILIADOS,
      COUNT(*) AS TOTAL_MO,
      
      
      -- 2. CONDICIONES GESTANTE
      SUM(CASE WHEN X_GESTANTE = '1' THEN 1 ELSE 0 END) AS TOTAL_GESTANTES,

            
      -- 3. RANGOS DE EDAD
      SUM(CASE WHEN N_EDADMESES < 36 THEN 1 ELSE 0 END) AS MENORES_3_AÑOS,
      SUM(CASE WHEN N_EDADANIO BETWEEN 3 AND 11 THEN 1 ELSE 0 END) AS NIÑOS_3_A_11_AÑOS,
      SUM(CASE WHEN N_EDADANIO BETWEEN 12 AND 19 THEN 1 ELSE 0 END) AS ADOLESCENTES_12_A_19_AÑOS,
  
  
        -- 4. CSE (Contando hogares únicos)
      COUNT(DISTINCT CASE WHEN cse = 'PE'  THEN ID_CORTE_HOGAR END) AS HOGARES_POBRES_EXTREMOS,
      COUNT(DISTINCT CASE WHEN cse = 'PNE' THEN ID_CORTE_HOGAR END) AS HOGARES_POBRES,
      
      -- 5. Nuevos hogares afiliados
      COUNT(DISTINCT CASE WHEN ID_CORTE = 324 AND TIPO_PADRON = '1' THEN ID_CORTE_HOGAR END) AS TOTAL_NUEVOS_AFILIADOS
    
        -- 6. HOGARES TPI
        
    --    COUNT(DISTINCT CASE WHEN HOGAR_TPI = '1' THEN ID_CORTE_HOGAR END ) AS HOGARES_TPI
        
  FROM DATA_DETALLE
  GROUP BY DISTRITO
  
  ;

---************ TRANSFERENCIA PRIMERA INFANCIA *********************

--LINK: https://app.powerbi.com/view?r=eyJrIjoiNTZiMzhhYmItN2Q5NC00NTg4LTllNDAtMGI4NmRhMDAyYTE4IiwidCI6IjA4N2Y4ZmZkLTY5NzItNDc1MC04ZjlhLWMwZTQ4YjU2YmQyZiJ9

-- RUTA: TRANSFERENCIA PRIMERA INFANCIA (TPI) > PADRON HOGARES ABONADOS: 6 BIM  > FILTRAR POR [DEPA] O LO QUE SE NECESITE (HOJA 2) - CANTIDAD CUADRO ROJO SUPERIOR DERECHO 


--************* CUADRO: INTERVENCION BIMESTRAL DEL DISTRITO *******************

--LINK: https://app.powerbi.com/view?r=eyJrIjoiNTZiMzhhYmItN2Q5NC00NTg4LTllNDAtMGI4NmRhMDAyYTE4IiwidCI6IjA4N2Y4ZmZkLTY5NzItNDc1MC04ZjlhLWMwZTQ4YjU2YmQyZiJ9

-- RUTA: TRANSFERENCIA BASE > PADRON DE HOGARES ABONADOS > FILTRAR POR [DEPA] O LO QUE SE PIDA + BIM , PARA PODER COMPLETAR EL CUADRO. (cuadro de hogares abonados)



