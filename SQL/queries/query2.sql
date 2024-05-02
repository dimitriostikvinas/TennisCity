SELECT user.username
FROM user
	JOIN coach on user.id = coach.user_id
WHERE Hourly_Rate BETWEEN 100 AND 300 AND Experience = 'expert';