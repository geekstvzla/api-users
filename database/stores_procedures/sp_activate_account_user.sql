CREATE PROCEDURE `sp_activate_account_user`(IN p_user_id TEXT, IN p_language_id INT, OUT p_response TEXT)
BEGIN
    
    SELECT IF(COUNT(1) > 0,TRUE, FALSE),
		   status_id
    INTO @v_user_exists,
         @v_user_status_id
    FROM users u
    INNER JOIN user_secure_id usi ON usi.user_id = u.user_id 
    WHERE usi.secure_id = p_user_id;

    IF @v_user_exists = 1 THEN
    
        SELECT u.user_id,
               u.username,
               u.email
		INTO @v_user_id,
             @v_username,
             @v_email
        FROM users u 
        INNER JOIN user_secure_id usi ON usi.user_id = u.user_id
        WHERE usi.secure_id = p_user_id;

		IF @v_user_status_id = 3 THEN

			UPDATE users u SET u.status_id = 1 WHERE u.user_id = @v_user_id;
            
			SELECT fn_messages("SP_ACTIVATE_ACCOUNT_USER", 1, 1, p_language_id) INTO @v_message_data;
		    SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
            
            SELECT CONCAT('{
				"response" : {
                    "email"      : "',@v_email,'",
					"message"    : "',@v_message,'",
                    "name"       : "',@v_username,'",
					"status"     : "success",
					"statusCode" : 1
				}
			}') INTO p_response;

        ELSEIF @v_user_status_id = 1 THEN
			
			SELECT fn_messages("SP_ACTIVATE_ACCOUNT_USER", 2, 1, p_language_id) INTO @v_message_data;
		    SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
            
			SELECT CONCAT('{
                "response" : {
					"message"    : "',@v_message,'",
                    "name"       : "',@v_username,'",
					"status"     : "success",
					"statusCode" : 2
				}
			}') INTO p_response;

        ELSE
			
            SELECT fn_messages("SP_ACTIVATE_ACCOUNT_USER", 3, 1, p_language_id) INTO @v_message_data;
		    SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
        
			SELECT CONCAT('{
				"response" : {
					"message"    : "',@v_message,'",
                    "name"       : "',@v_username,'",
					"status"     : "success",
					"statusCode" : 3
				}
			}') INTO p_response;

        END IF;

    ELSE
		
        SELECT fn_messages("SP_ACTIVATE_ACCOUNT_USER", 0, 1, p_language_id) INTO @v_message_data;
		SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
        
        SELECT CONCAT('{
			"response" : {
				"message"    : "',@v_message,'",
				"status"     : "error",
				"statusCode" : 0
			}
        }') INTO p_response;

    END IF;

END;