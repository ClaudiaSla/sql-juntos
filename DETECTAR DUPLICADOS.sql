--*****************************************DETECTAR DUPLICADOS******************************************* 

--TABLAS QUE SE UTILIZAN
SELECT*FROM SITC.PERSONA; --IDPERSONA - DNI - FNACIMIENTO - GENERO
SELECT*FROM SITC.MIEMBROAFI; -- SECMIEMBRO -IDPERSONA -IDHOGAR
SELECT*FROM SITC.HOGARAFI; -- IDHOGAR
SELECT*FROM SITC.HOGARDETALLEAFI; --IDHOGAR 
SELECT * FROM ESTADOHOGAR; -- T4

----VER IDHOGAR MEDIANTE DNI
select 
ha.F_REGISTRO_AFI,
ma.IDHOGAR,
p.DNI,
p.NOMBRE
from 
sitc.persona p 
join SITC.MIEMBROAFI ma on p.IDPERSONA = ma.IDPERSONA
join sitc.hogarafi ha on ha.IDHOGAR = ma.IDHOGAR
where p.DNI='93970628' ;

------------------------------------1.Consulta para obtener la data a analizar hasta hoy-------------------------------

SELECT
  T1.IDHOGAR,
  T3.IDPERSONA,
  T2.SECMIEMBRO,
  T3.DNI,
  T3.CODTIPODOCUMENTO,
  T3.NOMBRE || ' ' || T3.PAPELLIDO || ' ' || T3.SAPELLIDO AS "NOMBRES COMPLETOS",
  T3.FNACIMIENTO,
  T3.GENERO,
  T1.F_REGISTRO_AFI

FROM
  SITC.HOGARAFI T1
JOIN SITC.MIEMBROAFI T2 ON T1.IDHOGAR = T2.IDHOGAR
JOIN SITC.PERSONA T3 ON T2.IDPERSONA = T3.IDPERSONA
JOIN ESTADOHOGAR T4 ON T1.CODESTADOHOGAR = T4.CODESTADOHOGAR 

WHERE T4.CODESTADOHOGAR IN ('13','14') -- 13: Hogar elegible | 14: Hogares preafiliados
AND T1.MODALIDAD_INGRESO in ('1','2') --1:MASIVO | 2:DEMANDA
AND T2.VIGENTE = 1
AND TRUNC(T1.F_REGISTRO_AFI) BETWEEN TO_DATE('17/05/2025', 'DD/MM/YYYY') AND TO_DATE('31/12/2026', 'DD/MM/YYYY')
ORDER BY F_REGISTRO_AFI DESC; 

--1730 REGISTROS | 08-01-2026

----------------------------------------- 2.CONSULTA PARA GESTIONAR LA BAJA DE "MO" POR DUPLICIDAD CUANDO TENGAMOS EL "IDHOGAR"-------------------------------

--MOTIVO RECHAZO: SELECT*FROM sitc.motivorechazo;

SELECT
h.idhogar,
h.felegibilidad,
H.CODESTADOHOGAR,
m.secmiembro,
m.vigente,
m.codmotivorechazo,
null as VIGENTE_NEW,
null as CODMOTIVORECHAZO_NEW,
O.SECMOBJETIVO,
p.idpersona,
P.DNI,
P.Codtipodocumento,
p.nombre,
p.papellido,
p.sapellido,
p.fnacimiento,
p.genero

FROM sitc.persona p
INNER JOIN sitc.miembroafi m
ON  m.idpersona = p.idpersona
INNER JOIN sitc.hogarafi h
ON h.idhogar = m.idhogar
INNER JOIN sitc.mobjetivoafi o
ON o.secmiembro = m.secmiembro

WHERE m.vigente = '1'
AND o.vigente = 1
AND 
h.idhogar = '5765476' 
AND CODTIPODOCUMENTO='08' 
AND DNI ='92571919'
ORDER BY p.fnacimiento DESC;


-----------------------------3.CONSULTA PARA GESTIONAR LA BAJA DE "MH" POR DUPLICIDAD CUANDO TENGAMOS EL "IDHOGAR"---------------------------

SELECT
 h.idhogar,
 h.felegibilidad,
 H.CODESTADOHOGAR,
 m.secmiembro,
 m.vigente,
 m.codmotivorechazo,
 p.idpersona,
 P.DNI,
 P.Codtipodocumento,
 p.nombre,
 p.papellido,
 p.sapellido,
 p.fnacimiento,
 p.genero

FROM sitc.persona p
INNER JOIN sitc.miembroafi m
ON  m.idpersona = p.idpersona
INNER JOIN sitc.hogarafi h
ON h.idhogar = m.idhogar

WHERE m.vigente = '1'
AND h.idhogar = 5707858;
--AND P.DNI='XXX'


-- --------------------------------*******-4.CONSULTA PARA OBSERVAR EL DETALLE DEL PADRÓN NOMINAL********----------------------------------

SELECT*fROM PROCESO_MASIVO_UOP.TDCARGA_PADRON_NOMINAL WHERE NUDOCUMENTO_MENOR='92186093';

SELECT*FROM USR_UOP.CAGIO_PADRON_NOMINAL
WHERE DNI_DE_LA_MADRE = '48143458'
ORDER BY FE_CREA_REGISTRO DESC;

--RN DESDE EL 2025
SELECT
pn.FECHA_NAC_DEL_MENOR,
pn.*FROM SITC.TPADRON_NOMINAL pn
WHERE DNI_DEL_MENOR= '90358629' AND TO_DATE(FECHA_NAC_DEL_MENOR)>=TO_DATE('01/01/2025','DD/MM/YYYY')
ORDER BY FE_MODI_REGISTRO  DESC;

-- PARA EL MENOR DE EDAD
SELECT*FROM SITC.TPADRON_NOMINAL
WHERE nudocumento_menor = '94091781'
ORDER BY FE_MODI_REGISTRO DESC;

----------------------------------------------5.DETECTAR DUPLICADOS (SCRIPT FABI)-------------------------------------

-- LISTAR POSIBLES DUPLICADOS DE MIEMBROS DE HOGARES ELEGIBLES

SELECT 
x3.idhogar,
        x3.id_hogar_sisfoh,
        x3.f_registro_afi,
        x3.modalidad_ingreso,
        x1.idpersona,
        x2.secmiembro,
        x1.codtipodocumento,
        x1.dni,
        x1.cotejo,
        x1.fcotejo,
        x1.papellido,
        x1.sapellido,
        x1.nombre,
        x1.fnacimiento,
        x1.genero
FROM sitc.persona x1
JOIN sitc.miembroafi x2
    ON x2.idpersona=x1.idpersona
        AND x2.vigente='1'
JOIN sitc.hogarafi x3
    ON x3.idhogar=x2.idhogar
JOIN (
SELECT x3.idhogar||x1.fnacimiento llave,
        max(x1.codtipodocumento) codtipodocumento_max,
        min(x1.codtipodocumento) codtipodocumento_min

    FROM sitc.persona x1

JOIN sitc.miembroafi x2
    ON x2.idpersona=x1.idpersona
        AND x2.vigente='1'

JOIN sitc.hogarafi x3
    ON x3.idhogar=x2.idhogar

    WHERE x3.codestadohogar='13'

    GROUP BY  x3.idhogar||x1.fnacimiento

HAVING count (x3.idhogar||x1.fnacimiento)>1
        AND max(x1.codtipodocumento)<> min(x1.codtipodocumento)
 )aa
    ON aa.llave=x3.idhogar||x1.fnacimiento
ORDER BY x3.idhogar, x1.fnacimiento, x1.codtipodocumento;



--6.SCRIPT DETECTAR DUPLICADOS EN EL PN CON LA LLAVE: pp.dni_de_la_madre || pp.nudocumento_menor

SELECT 
    pp.id_pn,
    pp.dni_de_la_madre,
    pp.codtipodocumento_menor,
    pp.nudocumento_menor,
    pp.nu_fenacimiento,
    pp.genero_menor,
    pp.*
FROM sitc.tpadron_nominal pp
JOIN (
        SELECT 
            p.dni_de_la_madre || p.nudocumento_menor AS llave
        FROM sitc.tpadron_nominal p
        GROUP BY 
            p.dni_de_la_madre,
            p.nudocumento_menor
        HAVING COUNT(*) > 1
           AND MAX(p.codtipodocumento_menor) <> MIN(p.codtipodocumento_menor)
              
     ) a 
ON a.llave = pp.dni_de_la_madre || pp.nudocumento_menor
ORDER BY 
    pp.dni_de_la_madre,
    pp.nudocumento_menor,
    pp.genero_menor,
    pp.codtipodocumento_menor;


--7.SCRIPT DETECTAR DUPLICADOS EN EL PN CON LA LLAVE: pp.dni_de_la_madre || pp.nu_fenacimiento --MAIN

SELECT 
pp.id_pn,
        pp.dni_de_la_madre,
        pp.codtipodocumento_menor,
        pp.nudocumento_menor,
        pp.nu_fenacimiento,
        
pp.*
FROM sitc.tpadron_nominal pp
JOIN (
SELECT p.dni_de_la_madre||p.nu_fenacimiento llave

    FROM sitc.tpadron_nominal p 

    GROUP BY  p.dni_de_la_madre||p.nu_fenacimiento

HAVING count (p.dni_de_la_madre||p.nu_fenacimiento)>1
        AND max(p.codtipodocumento_menor)<>min(p.codtipodocumento_menor)
 )a
    ON a.llave=pp.dni_de_la_madre||pp.nu_fenacimiento

ORDER BY pp.dni_de_la_madre, pp.nu_fenacimiento, pp.codtipodocumento_menor;

SELECT*FROM SITC.TPADRON_NOMINAL WHERE EDAD_ANIO>6;





