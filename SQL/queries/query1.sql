SELECT user.username
FROM user 
	JOIN athlete ON user.id = athlete.user_id
WHERE athlete.skill_level = 'intermediate' AND user.postal_code = 56431
 
