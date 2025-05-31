CREATE FUNCTION `fn_check_username`(p_username TEXT, p_language_id VARCHAR(3)) RETURNS text CHARSET utf8mb4
BEGIN
    
    SELECT IF(COUNT(1) > 0, false, true)
    INTO @v_username_available
    FROM users u
	WHERE LOWER(u.username) = p_username;
                           
	IF @v_username_available = 0 THEN
		
        SET @v_status = "success";
        SET @v_status_code = 1;
            
    ELSE
        
        SET @v_status = "error";
        SET @v_status_code = 2;
		
    END IF;
    
    SELECT fn_messages("FN_CHECK_USERNAME", @v_status_code, 3, p_language_id) INTO @v_message_data;
	SELECT JSON_UNQUOTE(JSON_EXTRACT(@v_message_data, '$.message')) INTO @v_message;
    
	SET @v_response = CONCAT('{
        "message"           : "',@v_message,'",
        "status"            : "',@v_status,'",
        "statusCode"        : ',@v_status_code,',
        "usernameAvailable" : ',@v_username_available,'
    }');

	RETURN @v_response;

END;