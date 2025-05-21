CREATE PROCEDURE `sp_sign_in`(IN `p_email` TEXT, IN `p_access_code` INT, OUT `p_response` TEXT)
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
           u.access_code_expire_at
    INTO @v_user_id,
         @v_username,
         @v_avatar,
         @v_current_access_code,
         @v_secure_id,
         @v_expire_at
    FROM users u
    INNER JOIN user_secure_id usi ON usi.user_id = u.user_id
    WHERE u.email = p_email;
    
    IF @v_current_access_code = p_access_code AND NOW() <= @v_expire_at THEN
		
		SELECT fn_messages("SP_SING_IN", 1, 1) INTO @v_message_data;
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
        
	ELSE
    
		IF @v_current_access_code = p_access_code AND  NOW() > @v_expire_at THEN
			
			SET @v_user_id = 0;
			SET @v_status_code = 2;

		ELSEIF @v_current_access_code <> p_access_code THEN
			
			SET @v_user_id = 0;
			SET @v_status_code = 3;
		
		ELSE
			
			SET @v_user_id = 0;
			SET @v_status_code = 4;
		
		END IF;
		
		SELECT fn_messages("SP_SING_IN", @v_status_code, 1) INTO @v_message_data;
		SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
		
		SELECT CONCAT('{
			"response" : {
				"message"    : "',@v_message,'",
				"status"     : "error",
				"statusCode" : ',@v_status_code,'
			}
		}') INTO p_response;
    
    END IF;

END;