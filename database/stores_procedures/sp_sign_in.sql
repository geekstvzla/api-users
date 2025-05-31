CREATE PROCEDURE `sp_sign_in`(IN `p_email` TEXT, IN `p_access_code` INT, IN p_language_id VARCHAR(3), OUT `p_response` TEXT)
BEGIN

    SELECT u.user_id,
           u.username,
		   IF(
			   u.avatar IS NULL OR u.avatar = '',
			   'default-avatar.webp',
			   u.avatar
		   ) avatar,
           u.access_code,
           usi.secure_id,
           u.access_code_expire_at,
           u.status_id,
           s.description
    INTO @v_user_id,
         @v_username,
         @v_avatar,
         @v_current_access_code,
         @v_secure_id,
         @v_expire_at,
         @v_user_status_id,
         @v_user_status_desc
    FROM users u
    INNER JOIN user_secure_id usi ON usi.user_id = u.user_id
    INNER JOIN status s ON s.value = u.status_id
    WHERE u.email = p_email
    AND s.table = "users";
    
    IF @v_user_status_id = 1 THEN
    
		IF @v_current_access_code = p_access_code AND NOW() <= @v_expire_at THEN
			
			SELECT fn_messages("SP_SING_IN", 1, 1, p_language_id) INTO @v_message_data;
			SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
			
			SELECT CONCAT('{
				"response" : {
					"avatar"     : "',@v_avatar,'",
					"message"    : "',@v_message,'",
					"status"     : "success",
					"statusCode" : 1,
					"userId"     : "',@v_secure_id,'",
					"username"   : "',@v_username,'"
				}
			}') INTO p_response;
            
		ELSEIF @v_current_access_code = p_access_code AND  NOW() > @v_expire_at THEN
			
			SELECT LPAD(FLOOR(RAND() * 999999.99), 6, '0') INTO @v_login_code;
			SELECT NOW() + INTERVAL 2 MINUTE INTO @access_code_expiration_time;
			
			UPDATE users u SET u.access_code = @v_login_code,
							   u.access_code_expire_at = @access_code_expiration_time
			WHERE u.user_id = @v_user_id;
			
            SELECT fn_messages("SP_SING_IN", 2, 1, p_language_id) INTO @v_message_data;
			SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
			
			SELECT CONCAT('{
				"response" : {
                    "accessCode" : "',@v_login_code,'",
					"message"    : "',@v_message,'",
					"status"     : "warning",
					"statusCode" : 2
				}
			}') INTO p_response;
            
		ELSE
		
			IF @v_current_access_code <> p_access_code THEN

				SET @v_status = "error";
				SET @v_status_code = 3;
			
			ELSE

				SET @v_status = "error";
				SET @v_status_code = 4;
			
			END IF;
			
			SELECT fn_messages("SP_SING_IN", @v_status_code, 1, p_language_id) INTO @v_message_data;
			SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
			
			SELECT CONCAT('{
				"response" : {
					"message"    : "',@v_message,'",
					"status"     : "',@v_status,'",
					"statusCode" : ',@v_status_code,'
				}
			}') INTO p_response;
		
		END IF;
        
	ELSEIF @v_user_status_id = 3 THEN
		
        SELECT fn_messages("SP_GET_USER_ACCESS_CODE", 3, 1, p_language_id) INTO @v_message_data;
		SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
		
		SELECT CONCAT('{
			"response" : {
				"userId"     : "',@v_secure_id,'",
				"message"    : "',@v_message,'",
				"status"     : "warning",
				"statusCode" : 5
			}
		}') INTO p_response;
    
    ELSE
    
		SELECT fn_messages("SP_GET_USER_ACCESS_CODE", 2, 1, p_language_id) INTO @v_message_data;
		SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
		
		SELECT CONCAT('{
			"response" : {
				"message"    : "',@v_message,' <b>',@v_user_status_desc,'</b>",
				"status"     : "warning",
				"statusCode" : 6
			}
		}') INTO p_response;
    
    END IF;

END;