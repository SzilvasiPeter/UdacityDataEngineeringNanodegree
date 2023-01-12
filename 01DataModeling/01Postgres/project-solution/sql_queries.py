# DROP TABLES

songplay_table_drop = "DROP TABLE IF EXISTS songplay"
customer_table_drop = "DROP TABLE IF EXISTS customer"
song_table_drop = "DROP TABLE IF EXISTS song"
artist_table_drop = "DROP TABLE IF EXISTS artist"
time_table_drop = "DROP TABLE IF EXISTS time"

# CREATE TABLES

songplay_table_create = ("""
    CREATE TABLE IF NOT EXISTS songplay (
        songplay_id SERIAL PRIMARY KEY,
        customer_id INT REFERENCES customer (customer_id),
        song_id TEXT REFERENCES song (song_id),
        artist_id TEXT REFERENCES artist (artist_id),
        start_time TIMESTAMP REFERENCES time (start_time),
        session_id INT,
        level TEXT,
        location TEXT,
        customer_agent TEXT
        )
""")

customer_table_create = ("""
    CREATE TABLE IF NOT EXISTS customer (
        customer_id INT PRIMARY KEY,
        first_name TEXT,
        last_name TEXT,
        gender CHAR(1),
        level TEXT
    )
""")

song_table_create = ("""
    CREATE TABLE IF NOT EXISTS song (
        song_id TEXT PRIMARY KEY,
        artist_id TEXT REFERENCES artist (artist_id),
        title TEXT,
        year INT,
        duration REAL
    )
""")

artist_table_create = ("""
    CREATE TABLE IF NOT EXISTS artist (
        artist_id TEXT PRIMARY KEY,
        name TEXT,
        location TEXT,
        latitude REAL,
        longitude REAL 
    )
""")

time_table_create = ("""
    CREATE TABLE IF NOT EXISTS time (
        start_time TIMESTAMP PRIMARY KEY,
        hour INT,
        day INT,
        week INT,
        month INT,
        year INT,
        weekday INT
    )
""")

# INSERT RECORDS

songplay_table_insert = ("""
    INSERT INTO songplay (customer_id, song_id, artist_id, start_time, session_id, level, location, customer_agent)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
""")

customer_table_insert = ("""
    INSERT INTO customer (customer_id, first_name, last_name, gender, level)
    VALUES (%s, %s, %s, %s, %s)
    ON CONFLICT (customer_id) DO UPDATE SET level = EXCLUDED.level
""")

song_table_insert = ("""
    INSERT INTO song (song_id, artist_id, title, year, duration)
    VALUES (%s, %s, %s, %s, %s)
    ON CONFLICT (song_id) DO NOTHING
""")

artist_table_insert = ("""
    INSERT INTO artist (artist_id, name, location, latitude, longitude)
    VALUES (%s, %s, %s, %s, %s)
    ON CONFLICT (artist_id) DO NOTHING
""")


time_table_insert = ("""
    INSERT INTO time (start_time, hour, day, week, month, year, weekday)
    VALUES (%s, %s, %s, %s, %s, %s, %s)
    ON CONFLICT (start_time) DO NOTHING
""")

# FIND SONGS

song_select = ("""
    SELECT song.song_id, artist.artist_id 
    FROM song JOIN artist ON song.artist_id = artist.artist_id
    WHERE song.title=%s AND artist.name=%s AND song.duration=%s
""")

# QUERY LISTS

create_table_queries = [artist_table_create, song_table_create, customer_table_create, time_table_create, songplay_table_create]
drop_table_queries = [songplay_table_drop, customer_table_drop, song_table_drop, artist_table_drop, time_table_drop]