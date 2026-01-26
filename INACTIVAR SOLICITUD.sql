--************************INACTIVAR SOLICITUD*********************************

/*TABLAS QUE SE UTILIZAN:

select * from afi_postu.afitv_postulacion;
select * From AFI_POSTU.AFITM_ESTADO; */


SELECT
    p.id_solicitud,
    p.id_hogar_sisfoh,
    
    CASE 
      WHEN P.DE_CSE ='00220303' THEN 'NO POBRE'
      WHEN P.DE_CSE='00220302' THEN  'POBRE'
      WHEN P.DE_CSE='00220301'THEN 'POBRE EXTREMO'
      ELSE 'NO CLASIFICADO' 
    END CSE,
    
    p.fe_creacion,
    p.co_estado,
    NULL AS NUEVO_CO_ESTADO,
    p.fe_vigencia,
    p.nu_doc_solicitante
    
FROM afi_postu.afitv_postulacion p
JOIN juntos.tcpoblado c 
    ON c.c_depa || c.c_prov || c.c_dist || c.c_poblado = p.co_cpp
JOIN juntos.tdistrito dd 
    ON dd.c_depa || dd.c_prov || dd.c_dist = p.co_depa || p.co_prov || p.co_dist
JOIN juntos.tregion r 
    ON r.c_region = dd.c_region
JOIN afi_postu.afitm_estado est 
    ON est.co_estado = p.co_estado
LEFT JOIN afi_postu.afitm_motivo mm 
    ON mm.co_motivo = p.co_motivo
WHERE  p.nu_doc_solicitante = '40550389';

--p.nu_doc_solicitante = 'XXXXXXXX';
-- p.id_solicitud='XXXXX';

select*from afi_postu.afitv_postulacion ;
select * From AFI_POSTU.AFITV_MIEMBRO_GESTANTE;