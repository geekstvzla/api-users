CREATE PROCEDURE `sp_get_user_access_code`(IN `p_email` TEXT, OUT `p_response` TEXT)
BEGIN

    SELECT IF(COUNT(1) > 0,TRUE, FALSE)
    INTO @v_user_exists
    FROM users u
    WHERE u.email = p_email;
    
    IF @v_user_exists > 0 THEN

        SELECT u.user_id,
               u.username,
               IF(
                   u.avatar IS NULL OR u.avatar = '',
				   'default-avatar.webp',
                   u.avatar
               ) avatar,
               u.status_id,
               s.description
        INTO @v_user_id,
             @v_username,
             @v_avatar,
             @v_user_status_id,
             @v_user_status_desc
        FROM users u
        INNER JOIN status s ON s.value = u.status_id
        AND s.table = "users"
        WHERE u.email = p_email;

		IF @v_user_status_id = 3 THEN
			
			SELECT fn_messages("SP_GET_USER_ACCESS_CODE", 3, 1) INTO @v_message_data;
			SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
		
			SELECT CONCAT('{
				"response" : {
					"message"    : "',@v_message,'",
					"status"     : "warning",
					"statusCode" : 3
				}
			}') INTO p_response;

		ELSEIF @v_user_status_id = 1 THEN
			
			SELECT fn_messages("SP_GET_USER_ACCESS_CODE", 1, 1) INTO @v_message_data;
			SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
            SELECT FLOOR(0 + RAND() * 999999) INTO @v_login_code;
            SELECT NOW() + INTERVAL 2 MINUTE INTO @access_code_expiration_time;
            
            UPDATE users u SET u.access_code = @v_login_code,
                               u.access_code_expire_at = @access_code_expiration_time
			WHERE u.user_id = @v_user_id;
			
			SELECT CONCAT('{
				"response" : {
                    "accessCode" : ',@v_login_code,',
					"avatar"     : "',@v_avatar,'",
					"message"    : "',@v_message,'",
					"username"   : "',@v_username,'",
					"status"     : "success",
					"statusCode" : 1
				}
			}') INTO p_response;

		ELSE
			
			SELECT fn_messages("SP_GET_USER_ACCESS_CODE", 2, 1) INTO @v_message_data;
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
		
        SELECT fn_messages("SP_GET_USER_ACCESS_CODE", 0, 1) INTO @v_message_data;
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