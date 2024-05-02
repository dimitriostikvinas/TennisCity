SELECT mydb.match.id, mydb.match.date
FROM mydb.match JOIN venue ON mydb.match.venue_id = mydb.venue.id
WHERE mydb.match.date > '2023-02-03' AND mydb.venue.city = 'Thessaloniki - Greece';