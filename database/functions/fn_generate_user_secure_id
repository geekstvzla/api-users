CREATE FUNCTION `fn_generate_user_secure_id`() RETURNS text CHARSET utf8mb4
BEGIN

	SELECT LEFT(MD5(RAND()), 16) INTO @v_id;
    SELECT COUNT(1) INTO @v_exist FROM user_secure_id WHERE secure_id = @v_id;
    
    if @v_exist > 1 THEN
		CALL fn_generate_user_secure_id();
    END IF;
    
RETURN @v_id;
END;