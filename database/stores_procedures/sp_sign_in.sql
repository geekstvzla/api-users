CREATE PROCEDURE `sp_sign_in`(IN `p_email` TEXT, IN `p_access_code` INT, OUT `p_response` TEXT)
BEGIN

    SELECT u.user_id,
           u.access_code,
           u.access_code_expire_at
    INTO @v_user_id,
         @v_current_access_code,
         @v_expire_at
    FROM users u
    WHERE u.email = p_email;
    
    IF @v_current_access_code = p_access_code AND @v_expire_at <= NOW() THEN
		
		SELECT fn_messages("SP_SING_IN", 1, 1) INTO @v_message_data;
		SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
        
		SELECT CONCAT('{
			"response" : {
				"message"    : "',@v_message,'",
				"status"     : "success",
				"statusCode" : 1,
				"userId"     : ',@v_user_id,'
			}
		}') INTO p_response;
        
        SELECT CONCAT('{
			"response" : {
				"message"    : "',@v_message,'",
				"status"     : "error",
				"statusCode" : 1,
				"userId"     : ',@v_user_id,'
			}
		}') INTO p_response;
        
	ELSE
    
		IF @v_current_access_code = p_access_code AND @v_expire_at > NOW() THEN
			
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