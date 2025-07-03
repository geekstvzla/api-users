CREATE VIEW vw_gender_types AS

SELECT gtl.gender_type_id,
       gtl.language_id,
       l.code language_code,
       gtl.description gender,
       gt.status_id
FROM gender_types gt
INNER JOIN gender_types_lang gtl ON gtl.gender_type_id = gt.gender_type_id
INNER JOIN languages l ON l.language_id = gtl.language_id;