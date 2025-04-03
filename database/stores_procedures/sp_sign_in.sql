CREATE PROCEDURE `sp_sign_in`(IN `p_email` TEXT, OUT `p_response` TEXT)
BEGIN

    SELECT IF(COUNT(1) > 0,TRUE, FALSE)
    INTO @v_user_exists
    FROM users u
    WHERE u.email = p_email;
    
    IF @v_user_exists > 0 THEN

        SELECT `iv`,
               `key`
        INTO @v_encrypt_iv,
             @v_encrypt_key
        FROM vw_encryption_variables;

        SELECT u.user_id,
        	   CAST(AES_DECRYPT(u.password, @v_encrypt_key) AS CHAR),
               u.username,
               IF(
                   u.avatar IS NULL OR u.avatar = '',
				   'default-avatar.webp',
                   u.avatar
               ) avatar,
               u.status_id,
               s.description
        INTO @v_user_id,
             @v_password,
             @v_username,
             @v_avatar,
             @v_user_status_id,
             @v_user_status_desc
        FROM users u
        INNER JOIN status s ON s.value = u.status_id
        AND s.table = "users"
        WHERE u.email = p_email;
        
        IF p_password = @v_password THEN

            IF @v_user_status_id = 3 THEN
				
                SELECT fn_messages("SP_SING_IN", 3, 1, p_lang_id) INTO @v_message_data;
				SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
        
                SELECT CONCAT('{
                    "response" : {
					    "message"    : "',@v_message,'",
				        "status"     : "warning",
				        "statusCode" : 3,
                        "userId"     : ',@v_user_id,'
                    }
			    }') INTO p_response;

            ELSEIF @v_user_status_id = 1 THEN
				
                SELECT fn_messages("SP_SING_IN", 1, 1, p_lang_id) INTO @v_message_data;
				SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
                
            	SELECT CONCAT('{
                    "response" : {
					    "avatar"     : "',@v_avatar,'",
                        "message"    : "',@v_message,'",
                        "username"   : "',@v_username,'",
				        "status"     : "success",
				        "statusCode" : 1,
                        "userId"     : ',@v_user_id,'
					}
			    }') INTO p_response;

            ELSE
				
                SELECT fn_messages("SP_SING_IN", 2, 1, p_lang_id) INTO @v_message_data;
				SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
                
            	SELECT CONCAT('{
                    "response" : {
					    "message"    : "',@v_message,' <b>',@v_user_status_desc,'</b>",
				        "status"     : "warning",
				        "statusCode" : 2
					}
			    }') INTO p_response;

            END IF;

        ELSE
			
            SELECT fn_messages("SP_SING_IN", 4, 1, p_lang_id) INTO @v_message_data;
			SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
                
            SELECT CONCAT('{
                "response" : {
		            "message"    : "',@v_message,'",
		            "status"     : "error",
                    "statusCode" : 4
                }
		    }') INTO p_response;

        END IF;

    ELSE
		
        SELECT fn_messages("SP_SING_IN", 0, 1, p_lang_id) INTO @v_message_data;
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