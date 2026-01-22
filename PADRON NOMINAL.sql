/*
===============================================
Nombre: Consultas al Padrón Nominal 
------------------------------------------------------------------------------------ 
Descripción: Consultas para obtener la información del padrón nominal
PADRON NOMINAL
===============================================
*/
select * from sitc.tpadron_nominal; /*(final)*/
SELECT * FROM PROCESO_MASIVO_UOP.TCCARGA_PADRON_NOMINAL; /*(cabecera)*/
SELECT * FROM PROCESO_MASIVO_UOP.TDCARGA_PADRON_NOMINAL; /*(detalle)*/

select * from sitc.tsis_gest; /*(final)*/
SELECT * FROM PROCESO_MASIVO_UOP.TCCARGA_SIS_GESTANTE;  /*(cabecera)*/
SELECT * FROM PROCESO_MASIVO_UOP.TDCARGA_SIS_GESTANTE;  /*(detalle)*/

select * from SITC.CRPSALUDAFI;


-------------------- CABECERA DE LA TABLA DE LOS PROCESOS MASIVOS DEL PADRÓN NOMINAL------------------------
SELECT 
     ID_CARGA,
     FE_RECEPCION,
     NU_REGISTROS
FROM 
proceso_masivo_uop.tccarga_padron_nominal
--where id_carga between 476 and 488
ORDER BY ID_CARGA DESC; 

--476 - 488 | 01 - 13/01


select
edad_anio,
p.* from SITC.TPADRON_NOMINAL p where edad_anio>6;

SELECT *
FROM SITC.TPADRON_NOMINAL
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, FECHA_NAC_DEL_MENOR) / 12) > 6;


SELECT*FROM proceso_masivo_uop.tccarga_padron_nominal;

SELECT * FROM 
PROCESO_MASIVO_UOP.TDCARGA_PADRON_NOMINAL
WHERE ID_CARGA = '399';

-------------------DETALLE DE LA TABLA DE LOS PROCESOS MASIVOS DEL PADRÓN NOMINAL, PARA VER DATOS DE LA MAMÁ E HIJOS----------------

SELECT * FROM PROCESO_MASIVO_UOP.TDCARGA_PADRON_NOMINAL
where DNI_DE_LA_MADRE ='47974128';

SELECT
    *
FROM SITC.TPADRON_NOMINAL
where DNI_DE_LA_MADRE ='70068353';

SELECT * FROM PROCESO_MASIVO_UOP.TDCARGA_PADRON_NOMINAL
where DNI_DEL_MENOR ='92022245';

SELECT * FROM SITC.TPADRON_NOMINAL
where DNI_DEL_MENOR ='';


-- DIA ELEGIBLE - FNACIMIENTO DEL MENOR

SELECT TO_DATE('25/07/2025','DD/MM/YYYY')-TO_DATE('25/06/2025','DD/MM/YYYY') +1 DIAS_NACIDO FROM DUAL;

--------------------------------CARGAS MASIVAS INSUMO---------------------

SELECT * FROM PROCESO_MASIVO_UOP.TDCARGA_PADRON_NOMINAL;
