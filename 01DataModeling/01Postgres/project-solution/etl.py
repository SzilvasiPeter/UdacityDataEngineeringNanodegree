import os
import glob

import psycopg2
import pandas as pd

from sql_queries import *


def process_song_file(cur, filepath):
    """
    This procedure processes a song file whose filepath has been provided as an arugment.
    It extracts the song and artist information to store it into the song and artist table respectively.

    Parameters
    ----------
    cur : cursor
        The database connection cursor.
    filepath : str
        The file path to the song file.
    """
    # open song file
    df = pd.read_json(filepath, lines=True)

    # insert artist record
    artist_data = df[['artist_id', 'artist_name', 'artist_location', 'artist_latitude', 'artist_longitude']].values[0].tolist()
    cur.execute(artist_table_insert, artist_data)

    # insert song record
    song_data = df[['song_id', 'artist_id', 'title', 'year', 'duration']].values[0].tolist()
    cur.execute(song_table_insert, song_data)


def process_log_file(cur, filepath):
    """
    This procedure processes a log file whose filepath has been provided as an argument.
    It filters the data where the action is NextSong.
    After converting timestamp column to datetime, it inserts the time data the time table.
    Next, it adds the customer related data to the customer table.
    Once all the dimension tables are populated, it inserts the records into the songplay fact table.

    Parameters
    ----------
    cur : cursor
        The database connection cursor.
    filepath : str
        The file path to the log file.
    """
    # open log file
    df = pd.read_json(filepath, lines=True)

    # filter by NextSong action
    df = df[df['page'] == 'NextSong']

    # convert timestamp column to datetime
    t = pd.to_datetime(df['ts'], unit='ms')

    # insert time data records
    time_data = [t, t.dt.hour, t.dt.day, t.dt.isocalendar().week, t.dt.month, t.dt.year, t.dt.weekday]
    column_labels = ('start_time', 'hour', 'day', 'week', 'month', 'year', 'weekday')
    time_df = pd.DataFrame.from_dict(dict(zip(column_labels, time_data)))

    for index, row in time_df.iterrows():
        cur.execute(time_table_insert, list(row))

    # load user table
    customer_df = df[['userId', 'firstName', 'lastName', 'gender', 'level']]

    # insert user records
    for index, row in customer_df.iterrows():
        cur.execute(customer_table_insert, row)

    # insert songplay records
    for index, row in df.iterrows():
        
        # get songid and artistid from song and artist tables
        cur.execute(song_select, (row.song, row.artist, row.length))
        results = cur.fetchone()
        
        if results:
            songid, artistid = results
        else:
            songid, artistid = None, None

        # insert songplay record
        songplay_data = (row.userId, songid, artistid, t[index], row.sessionId, row.level, row.location, row.userAgent)
        cur.execute(songplay_table_insert, songplay_data)


def process_data(cur, conn, filepath, func):
    """
    This procedure processes JSON files whose filepath has been provided as an argument.
    It iterates over all the files then processes them using the `func` function. 

    Parameters
    ----------
    cur : cursor
        The database connection cursor.
    conn : connection
        The connection to a PostgreSQL database instance.
    filepath : str
        The file path to the JSON files.
    func : function
        The function to process the JSON files.
    """
    # get all files matching extension from directory
    all_files = []
    for root, dirs, files in os.walk(filepath):
        files = glob.glob(os.path.join(root,'*.json'))
        for f in files :
            all_files.append(os.path.abspath(f))

    # get total number of files found
    num_files = len(all_files)
    print('{} files found in {}'.format(num_files, filepath))

    # iterate over files and process
    for index, datafile in enumerate(all_files, 1):
        func(cur, datafile)
        conn.commit()
        print('{}/{} files processed.'.format(index, num_files))


def main():
    conn = psycopg2.connect("host=127.0.0.1 dbname=sparkifydb user=student password=student")
    cur = conn.cursor()

    process_data(cur, conn, filepath='data/song_data', func=process_song_file)
    process_data(cur, conn, filepath='data/log_data', func=process_log_file)

    conn.close()


if __name__ == "__main__":
    main()