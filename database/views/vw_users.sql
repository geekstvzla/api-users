CREATE VIEW vw_users AS
SELECT u.user_id,
       usi.secure_id,
       u.document_type_id,
       u.document_id,
       u.blood_type_id,
       bt.description AS blood_type,
       u.email,
       u.username,
       u.first_name,
       u.middle_name,
       u.last_name,
       u.second_last_name,
       u.gender_id,
       u.birthday,
       u.phone_number,
       u.emergency_phone,
       u.medical_condition,
       u.status_id,
       s.description AS status
FROM users u
INNER JOIN user_secure_id usi ON usi.user_id = u.user_id
LEFT JOIN blood_type bt ON bt.blood_type_id = u.blood_type_id
INNER JOIN status s ON s.value = u.status_id
WHERE s.table = "users";