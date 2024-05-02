from flask import Flask, render_template, request, redirect, url_for, jsonify, session, render_template, send_from_directory
from flask_bcrypt import Bcrypt
import jwt
from datetime import datetime
import binascii
import pymysql.cursors  

app = Flask(__name__)
SECRET_KEY = 'secret_key'
app.secret_key = SECRET_KEY
bcrypt = Bcrypt(app)

# # Database connection configuration
# connection = pymysql.connect(
#     host='localhost',
#     user='root',
#     port=3306,
#     password='1234567890Aa',
#     database='mydb',
#     cursorclass=pymysql.cursors.DictCursor
# )

connection = pymysql.connect(
    host='127.0.0.1',
    user='root',
    port=3306,
    password='Kwdikos12!@',
    database='mydb',
    cursorclass=pymysql.cursors.DictCursor
)



@app.route('/static/<path:filename>')
def static_files(filename):
    return send_from_directory('static', filename)


def generate_token(username):
    payload = {'username': username}
    token = jwt.encode(payload, SECRET_KEY, algorithm='HS256')
    return token




def get_roles(user_id):
    roles = []
    with connection.cursor() as cursor:
        cursor.execute('SELECT * FROM athlete WHERE user_id = %s', (user_id,))
        athlete_data = cursor.fetchone()
        cursor.execute('SELECT * FROM coach WHERE user_id = %s', (user_id,))
        coach_data = cursor.fetchone()
    if athlete_data:
        roles.append('athlete')
    if coach_data:
        roles.append('coach')
    
    roles.append('user')
    return roles
    
@app.route('/register', methods=['GET', 'POST'])
def register():
    # Handle the GET request here
    if request.method == 'GET':
        return render_template('register.html')
    # Handle the POST request here
    if request.method == 'POST':
        # Process the form data and register the user
        username = request.form.get('username')
        password = request.form.get('password')
        city = request.form.get('city')
        email = request.form.get('email')
        contact_number = request.form.get('contact_number')
        date_of_birth = request.form.get('date_of_birth')
        gender=  request.form.get('gender')

        password_hash = bcrypt.generate_password_hash(password)
        with connection.cursor() as cursor:
            cursor.execute("INSERT INTO user (username, password_hash, city, email, contact_number, date_of_birth, gender) VALUES (%s, %s, %s, %s, %s, %s, %s)",
                        (username, password_hash, city, email, contact_number, date_of_birth,gender))
            connection.commit()
        return redirect(url_for('login'))
        
@app.route('/login', methods=['GET','POST'])
def login():
    if request.method=='GET':
        return render_template('login.html')
    
    if request.method=='POST':
        

        username = request.json.get('username')
        entered_password = request.json.get('password')  

        with connection.cursor() as cursor:
            cursor.execute('SELECT id,username, password_hash FROM user WHERE username = %s ', (username,))
            user_data = cursor.fetchone()

        if user_data:
            entered_password = entered_password.encode('utf-8')
            if bcrypt.check_password_hash(user_data['password_hash'], entered_password):
                session['username'] = user_data['username']  
                session['id'] = user_data['id']
                session['roles'] = get_roles(user_data['id'])
                token = generate_token(username)  
                return jsonify({'access_token': token})
            
            else:
                return jsonify({'error': 'Invalid password'}), 401
        else:
            return jsonify({'error': 'User not found'}), 404
        
@app.route('/logout')
def logout():
    # Clear the session to log out the user
    session.pop('username', None)
    return redirect(url_for('login'))


@app.route('/homepage')
def homepage():
    username = session.get('username')
    if username is None:
        return redirect(url_for('login'))
    
    roles = get_roles(session.get('id'))

    is_athlete = True if 'athlete' in roles else False
    is_coach = True if 'coach' in roles else False   
    
    return render_template('homepage.html', is_athlete=is_athlete, is_coach=is_coach)

@app.route('/profile')
def profile():
    if 'username' not in session:
        return redirect(url_for('login'))
    
    logged_in_user_id = session.get('id')
    
    with connection.cursor() as cursor:
        cursor.execute('SELECT * FROM user WHERE id = %s',(logged_in_user_id,))
        user_data = cursor.fetchone()
        
        cursor.execute('SELECT * FROM athlete WHERE user_id = %s',(logged_in_user_id,))
        athlete_data = cursor.fetchone()
        
        cursor.execute('SELECT * FROM coach WHERE user_id = %s',(logged_in_user_id,))
        coach_data = cursor.fetchone()
        
    return render_template('profile.html', user_data=user_data, athlete_data=athlete_data, coach_data=coach_data)


@app.route('/update_user/<int:user_id>', methods=['POST'])
def update_user(user_id):
    # Get form data from the request
    form_data = request.json

    with connection.cursor() as cursor:
        # Fetch the user from the database
        cursor.execute(f"SELECT * FROM user WHERE id = {user_id}")
        user = cursor.fetchone()

        if user:
            # Update user data
            update_query = f"""
            UPDATE user
            SET date_of_birth = '{form_data['dateOfBirth']}',
                contact_number = '{form_data['contactNumber']}',
                email = '{form_data['email']}',
                gender = '{form_data['gender']}',
                postal_code = '{form_data['postalCode']}',
                city = '{form_data['city']}'
            WHERE id = {user_id}
            """
            cursor.execute(update_query)
            connection.commit()

            return jsonify({'message': 'User updated successfully'})
        else:
            return jsonify({'message': 'User not found'}), 404

@app.route('/update_athlete/<int:athlete_user_id>', methods=['POST'])
def update_athlete(athlete_user_id):
    # Get form data from the request
    form_data = request.json

    with connection.cursor() as cursor:
        # Fetch the user from the database
        cursor.execute(f"SELECT * FROM athleteWHERE user_id = {athlete_user_id}")
        user = cursor.fetchone()

        if user:
            # Update user data
            update_query = f"""
            UPDATE athlete
            SET date_of_birth = '{form_data['dateOfBirth']}',
                contact_number = '{form_data['contactNumber']}',
                email = '{form_data['email']}',
                gender = '{form_data['gender']}',
                postal_code = '{form_data['postalCode']}',
                city = '{form_data['city']}'
            WHERE id = {athlete_user_id}
            """
            cursor.execute(update_query)
            connection.commit()

            return jsonify({'message': 'User updated successfully'})
        else:
            return jsonify({'message': 'User not found'}), 404





@app.route('/register_as_athlete', methods=['GET', 'POST'])
def register_as_athlete():
    if request.method == 'GET':
        return render_template('register_as_athlete.html')
    if request.method == 'POST':
        height = request.form.get('height')
        skill_level = request.form.get('skill_level')
        
        with connection.cursor() as cursor:
             
            cursor.execute('INSERT INTO athlete (user_id, height, skill_level) VALUES (%s, %s, %s)', (session.get('id'), height, skill_level))
            connection.commit()
            
        session['roles'].append('athlete')
        
            
        return redirect(url_for('homepage'))

@app.route('/register_as_coach', methods=['GET', 'POST'])
def register_as_coach():
    if request.method == 'GET':
        return render_template('register_as_coach.html')
    if request.method == 'POST':
        hourly_rate = request.form.get('hourly_rate')
        experience = request.form.get('experience')
        
        with connection.cursor() as cursor:
            
            cursor.execute('INSERT INTO coach (user_id,hourly_rate,experience) VALUES (%s, %s, %s)', 
                           (session.get('id'), hourly_rate, experience))
            connection.commit()
            
        return redirect(url_for('homepage'))








@app.route('/athletes_in_your_city')
def athletes():
    if 'username' not in session:
        return redirect(url_for('login'))

    logged_in_user_id = session.get('id')
    
    with connection.cursor() as cursor:
        cursor.execute('SELECT city FROM user WHERE id = %s',(logged_in_user_id,))
        city = cursor.fetchone()['city']
        
        # Fetch athletes in the same city as the logged-in athlete (excluding the logged-in user)
        cursor.execute("SELECT * FROM athlete AS a JOIN user AS u ON a.user_id = u.id WHERE a.user_id != %s AND u.city = (SELECT city FROM user WHERE id = %s)",
                       (logged_in_user_id, logged_in_user_id,))
        athletes = cursor.fetchall()
    
        cursor.execute("SELECT * FROM venue WHERE city = %s",(city,))
        venues = cursor.fetchall()
        
        
        
      #########  Fetch pairs to exclude the option of inviting to pair for already teamates #########
        cursor.execute("SELECT pair_id FROM pair_has_athlete WHERE athlete_user_id = %s",
                       (logged_in_user_id,))
        pairs = cursor.fetchall()
        for pair in pairs:
            cursor.execute("SELECT * FROM pair_has_athlete JOIN user ON user.id = athlete_user_id WHERE pair_id = %s AND athlete_user_id != %s ",
                           (pair['pair_id'],logged_in_user_id))
            pair['teamate'] = cursor.fetchone()
        
        for pair in pairs:
            for athlete in athletes:
                if athlete['id'] == pair['teamate']['id']:
                    athlete['is_teamate'] = True

    # Render the athletes template with the retrieved data
    return render_template('athletes_in_your_city.html',city=city,venues=venues, athletes=athletes)



@app.route('/coaches_in_your_city')
def coaches():
    if 'username' not in session:
        return redirect(url_for('login'))
    
    logged_in_user_id = session.get('id')
    
    with connection.cursor() as cursor:
        cursor.execute('SELECT city FROM user WHERE id = %s',(logged_in_user_id,))
        city = cursor.fetchone()['city']
        
        # Fetch coaches in the same city as the logged-in athlete (excluding the logged-in user)
        cursor.execute("SELECT * FROM coach AS c JOIN user AS u ON c.user_id = u.id WHERE c.user_id != %s AND u.city = (SELECT city FROM user WHERE id = %s)",
                       (logged_in_user_id, logged_in_user_id,))
        coaches = cursor.fetchall()
        
    # Render the coaches template with the retrieved data
    return render_template('coaches_in_your_city.html',city=city, coaches=coaches)

@app.route('/your_pairs')
def pairs():
    if 'username' not in session:
        return redirect(url_for('login'))
    
    logged_in_user_id = session.get('id')
    
    with connection.cursor() as cursor:

        cursor.execute("SELECT pair_id FROM pair_has_athlete WHERE athlete_user_id = %s",
                       (logged_in_user_id,))
        pairs = cursor.fetchall()
        
        for pair in pairs:
            cursor.execute("SELECT * FROM pair_has_athlete JOIN user ON user.id = athlete_user_id WHERE pair_id = %s AND athlete_user_id != %s ",
                           (pair['pair_id'],logged_in_user_id))
            pair['teamate'] = cursor.fetchone()
        
    return render_template('your_pairs.html', your_pairs=pairs)

@app.route('/delete_pair/<int:pair_id>', methods=['POST'])
def delete_pair(pair_id):
    if 'username' not in session:
        return redirect(url_for('login'))
    
    with connection.cursor() as cursor:
        cursor.execute("DELETE FROM pair_has_athlete WHERE pair_id = %s",
                       (pair_id,))
        cursor.execute("DELETE FROM pair WHERE id = %s",
                       (pair_id,))
        connection.commit()
    
    return jsonify({'message': 'Pair deleted successfully'})


@app.route('/invite_to_pair/<int:teamate_id>', methods=['POST'])
def create_pair(teamate_id):
    logged_in_user_id = session.get('id')
    
    #create_pair_entry
    with connection.cursor() as cursor:
        cursor.execute("INSERT INTO `pair` (creation_date) VALUES (%s)",(datetime.now(),))
        new_pair_id = cursor.lastrowid
        connection.commit()
    
    create_pair_has_athlete_entries(new_pair_id,teamate_id, logged_in_user_id)
    
    return jsonify({'message': 'Pair created successfully'})
    
    
def create_pair_has_athlete_entries(pair_id, teamate_id, logged_in_user_id):
    with connection.cursor() as cursor:
        cursor.execute(
            "INSERT INTO `pair_has_athlete` (pair_id, athlete_user_id) VALUES (%s, %s)",
            (pair_id, teamate_id)
        )
        cursor.execute(
            "INSERT INTO `pair_has_athlete` (pair_id, athlete_user_id) VALUES (%s, %s)",
            (pair_id, logged_in_user_id)
        )
        connection.commit()
    
    return jsonify({'message': 'Pair created successfully'})

    

    

@app.route('/invite_to_match/<int:player_id>', methods=['POST'])
def invite_to_match(player_id):
    
    if 'username' not in session:
        return redirect(url_for('login'))
    logged_in_user_id = session.get('id')
    
    # Handle the form submission here (when the user sends an invitation)
    if request.method == 'POST':
        # Process the form data and send the invitation
        date_str = request.form.get('date')
        venue = request.form.get('venue')
        # Convert the date string to a datetime object
        date = datetime.strptime(date_str, '%Y-%m-%d')
        
        match_id = create_match_entry(venue,date)
        create_athlete_plays_match_entry(player_id, match_id, 'not played yet')
        create_athlete_plays_match_entry(logged_in_user_id, match_id, 'not played yet')

        # Redirect to a different page after form submission
        return redirect(url_for('homepage'))
    
    



@app.route('/your_matches', methods=['GET', 'POST'])
def show_your_matches():
    if 'username' not in session:
        return redirect(url_for('login'))

    logged_in_user_id = session.get('id')
    
    # Handle the form submission here (when the user updates a match result)
    if request.method == 'POST':
        match_id = request.form.get('match_id')
        new_result = request.form.get('new_result')

        with connection.cursor() as cursor:
            cursor.execute("UPDATE athlete_plays_match SET result = %s WHERE match_id = %s and athlete_user_id = %s",
                        (new_result, match_id, logged_in_user_id))
            
            cursor.execute("UPDATE athlete_plays_match SET result = %s WHERE match_id = %s and athlete_user_id != %s",
                           ("lost" if new_result=="won" else "won", match_id, logged_in_user_id))
            connection.commit()
        return jsonify({'message': 'Match result updated successfully'})
        
        
    with connection.cursor() as cursor:
    
        cursor.execute(
            "SELECT athlete_plays_match.*, `match`.*, other_athletes.athlete_user_id AS other_athlete_id, other_users.username AS other_username "
            "FROM athlete_plays_match "
            "JOIN `match` ON athlete_plays_match.match_id = `match`.id "
            "JOIN athlete_plays_match AS other_athletes ON athlete_plays_match.match_id = other_athletes.match_id "
            "JOIN user AS other_users ON other_athletes.athlete_user_id = other_users.id "
            "WHERE athlete_plays_match.athlete_user_id = %s AND other_athletes.athlete_user_id != %s "
            "ORDER BY `athlete_plays_match`.`result` = 'not played yet' DESC, `match`.`date`", 
            (logged_in_user_id, logged_in_user_id)
        )
        entries = cursor.fetchall()
    return render_template('your_matches.html',entries=entries)




@app.route('/create_tournament', methods=['GET', 'POST'])
def create_tournament():
    if request.method == 'POST':
        tournament_type = request.form.get('tournament_type')
        name = request.form.get('name')
        start_date = request.form.get('start_date')
        end_date = request.form.get('end_date')
        organizer_user_id = session.get('id')
        # Insert logic to create a new tournament entry in the database
        # Use the form data to populate the fields
        with connection.cursor() as cursor:
            cursor.execute("INSERT INTO tournament (tournament_type, name, start_date, end_date, organizer_user_id) VALUES (%s, %s, %s, %s,%s)",
                           (tournament_type, name, start_date, end_date,organizer_user_id))
            connection.commit()

        return redirect(url_for('tournament_success'))

    return render_template('create_tournament.html')






def create_match_entry(venue,date):
    # Insert logic to create a new match entry in the database
    # Return the autogenerated match ID
    with connection.cursor() as cursor:
        cursor.execute(
            "INSERT INTO `match` (venue_id,date) VALUES (%s,%s)",(venue,date)
        )
        connection.commit()
    match_id = cursor.lastrowid  # Get the autogenerated match ID
    return match_id

def create_athlete_plays_match_entry(athlete_id, match_id, result):
    # Insert logic to create a new entry in the athlete_plays_match table
    with connection.cursor() as cursor:
        cursor.execute(
            "INSERT INTO `athlete_plays_match` (athlete_user_id, match_id, result) VALUES (%s, %s, %s)",
            (athlete_id, match_id, result)
        )
        connection.commit()
        
        

# if __name__ == '__main__':
#     app.run(debug=True, host='0.0.0.0', port=8080)

if __name__ == '__main__':
    app.run(port=8080)