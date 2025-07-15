CREATE PROCEDURE `sp_update_user_personal_data`(
	IN p_user_id TEXT, 
    IN p_first_name VARCHAR(50),
    IN p_middle_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_second_last_name VARCHAR(50),
    IN p_document_type_id INT(2),
    IN p_document VARCHAR(15),
    IN p_birthday DATE,
    IN p_gender_id INT(1),
    IN p_blood_type_id INT(1),
    IN p_phone_number VARCHAR(20),
    IN p_emergency_phone_number VARCHAR(20),
    IN p_medical_condition TEXT,
    IN p_language_id VARCHAR(3), 
    OUT p_response TEXT
) BEGIN
    
    SELECT IF(COUNT(1) > 0,TRUE, FALSE),
		   status_id
    INTO @v_user_exists,
         @v_user_status_id
    FROM users u
    INNER JOIN user_secure_id usi ON usi.user_id = u.user_id 
    WHERE usi.secure_id = p_user_id;

    IF @v_user_exists = 1 THEN
    
        SELECT u.user_id,
               u.document_type_id,
               u.document_id,
               u.blood_type_id,
               u.first_name,
               u.middle_name,
               u.last_name,
               u.second_last_name,
               u.gender_id,
               u.birthday,
               u.phone_number,
               u.emergency_phone,
               u.medical_condition
		INTO @v_user_id,
             @v_document_type_id,
             @v_document_id,
             @v_blood_type_id,
             @v_first_name,
             @v_middle_name,
             @v_last_name,
             @v_second_last_name,
             @v_gender_id,
             @v_birthday,
             @v_phone_number,
             @v_emergency_phone,
             @v_medical_condition
        FROM users u 
        INNER JOIN user_secure_id usi ON usi.user_id = u.user_id
        WHERE usi.secure_id = p_user_id;

		IF @v_user_status_id = 1 THEN -- Usuario activo

			IF p_first_name != @v_first_name THEN
				UPDATE users u  SET u.first_name = p_first_name WHERE u.user_id = @v_user_id;
            END IF;
            
            IF p_middle_name != @v_middle_name THEN
				UPDATE users u  SET u.middle_name = p_middle_name WHERE u.user_id = @v_user_id;
            END IF;
            
            IF p_last_name != @v_last_name THEN
				UPDATE users u  SET u.last_name = p_last_name WHERE u.user_id = @v_user_id;
            END IF;
            
            IF p_second_last_name != @v_second_last_name THEN
				UPDATE users u  SET u.second_last_name = p_second_last_name WHERE u.user_id = @v_user_id;
            END IF;
            
            IF p_document_type_id != @v_document_type_id THEN
				UPDATE users u  SET u.document_type_id = p_document_type_id WHERE u.user_id = @v_user_id;
            END IF;
            
            IF p_document != @v_document_id THEN
				UPDATE users u  SET u.document_id = p_document WHERE u.user_id = @v_user_id;
            END IF;
            
            IF p_birthday != @v_birthday THEN
				UPDATE users u  SET u.birthday = p_birthday WHERE u.user_id = @v_user_id;
            END IF;
            
            IF p_gender_id != @v_gender_id THEN
				UPDATE users u  SET u.gender_id = p_gender_id WHERE u.user_id = @v_user_id;
            END IF;
            
            IF p_blood_type_id != @v_blood_type_id THEN
				UPDATE users u  SET u.blood_type_id = p_blood_type_id WHERE u.user_id = @v_user_id;
            END IF;
            
            IF p_phone_number != @v_phone_number THEN
				UPDATE users u  SET u.phone_number = p_phone_number WHERE u.user_id = @v_user_id;
            END IF;
            
            IF p_emergency_phone_number != @v_emergency_phone THEN
				UPDATE users u  SET u.emergency_phone = p_emergency_phone_number WHERE u.user_id = @v_user_id;
            END IF;
            
            IF p_medical_condition != @v_medical_condition THEN
				UPDATE users u  SET u.medical_condition = p_medical_condition WHERE u.user_id = @v_user_id;
            END IF;
            
			SELECT fn_messages("SP_UPDATE_USER_PERSONAL_DATA", 0, 1, p_language_id) INTO @v_message_data;
		    SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
            
            SELECT CONCAT('{
				"response" : {
					"message"    : "',@v_message,'",
					"status"     : "success",
					"statusCode" : 1
				}
			}') INTO p_response;

        ELSEIF @v_user_status_id = 3 THEN -- Usuario pendiente de verificación
			
			SELECT fn_messages("SP_UPDATE_USER_PERSONAL_DATA", 3, 1, p_language_id) INTO @v_message_data;
		    SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
            
            SELECT CONCAT('{
				"response" : {
					"message"    : "',@v_message,'",
					"status"     : "warning",
					"statusCode" : 3
				}
			}') INTO p_response;

        ELSE
			
            SELECT fn_messages("SP_UPDATE_USER_PERSONAL_DATA", 2, 1, p_language_id) INTO @v_message_data;
		    SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
            
            SELECT CONCAT('{
				"response" : {
					"message"    : "',@v_message,'",
					"status"     : "warning",
					"statusCode" : 2
				}
			}') INTO p_response;

        END IF;

    ELSE
		
        SELECT fn_messages("SP_UPDATE_USER_PERSONAL_DATA", 0, 1, p_language_id) INTO @v_message_data;
		SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
        
        SELECT CONCAT('{
			"response" : {
				"message"    : "',@v_message,'",
				"status"     : "error",
				"statusCode" : 0
			}
        }') INTO p_response;

    END IF;

END