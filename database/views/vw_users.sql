CREATE VIEW vw_users AS
SELECT u.user_id,
       usi.secure_id,
       u.document_type_id,
       u.document_id,
       u.blood_type_id,
       u.email,
       u.username,
       u.first_name,
       u.middle_name,
       u.last_name,
       u.second_last_name,
       u.gender_id,
       u.birthday,
       u.phone_number
FROM users u
INNER JOIN user_secure_id usi ON usi.user_id = u.user_id;