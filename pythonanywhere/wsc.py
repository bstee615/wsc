# To use this app:
#   pip install bottle

import enum

import bottle
from datetime import datetime
from mysql.connector import connect


def get_login_info():
    file = open('login.conf')
    info = []
    for line in file:
        info.append(line.split('=')[1].strip())

    return tuple(info)


username, password, database, hostname = get_login_info()
con = connect(user=username, password=password, database=database, host=hostname)
cursor = con.cursor()

cursor.execute('SHOW TABLES;')
print(cursor.fetchall())

template_service_id = None
template_songleader_id = None
datetime_format = '%m/%d/%y %I:%M %p'
css = """
        <style display="none">
            * { display: block; margin: 4px; }
            style, script, title { display:none }
        </style>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">
        """

def serviceExists(dt: str):
    cursor.execute("""
    SELECT service_ID
    FROM service
    WHERE Svc_DateTime = '{0}'
    """.format(dt))
    return cursor.fetchall()


def create_record(data):
    if serviceExists(data['Svc_DateTime']):
        return None
    else:
        fields = {
            'Svc_DateTime': data['Svc_DateTime'],
            'Theme': data['Theme'],
            'Title': data['Title'],
            'Songleader_ID': template_songleader_id,
            'Pianist_Conf': False,
            'Organist_Conf': False,
            'Songleader_Conf': True
        }
        # Replace all empty strings with NULL
        for key in fields:
            if isinstance(fields[key], str) and not fields[key]:
                fields[key] = None

        # Insert service record
        insert_record = """
                        INSERT INTO service
                        (Svc_DateTime, Theme, Title,
                            Songleader_ID, Pianist_Conf,
                            Organist_Conf, Songleader_Conf)
                        Values(
                        %(Svc_DateTime)s, %(Theme)s, %(Title)s,
                            %(Songleader_ID)s, %(Pianist_Conf)s,
                            %(Organist_Conf)s, %(Songleader_Conf)s
                        )
                        """
        cursor.execute(insert_record, fields)

        # Insert all serviceevents from this service
        newsid = cursor.lastrowid
        fields = {
            'service_ID': newsid,
            'Confirmed': 'N',
            'Old_service_ID': template_service_id
        }
        insert_record = """
            INSERT INTO serviceevent(
                service_ID, Seq_Num, EventType_ID, Confirmed)
            SELECT %(service_ID)s, serviceevent.Seq_Num,
                serviceevent.EventType_ID, %(Confirmed)s
            FROM service JOIN serviceevent
            ON service.service_ID = serviceevent.service_ID
            WHERE service.service_ID = %(Old_service_ID)s
        """
        cursor.execute(insert_record, fields)

        con.commit()

    return newsid

def insertCongSongs(data):
    try:
        this_service_id = data['service_ID']

        for key in data:
            if key != 'service_ID':
                seqnum = int(key)

                cursor.execute("""
                SELECT Song_ID
                FROM song
                WHERE Title = '{}'
                """.format(data[key]))
                song_id = cursor.fetchall()[0][0]

                cursor.execute("""
                UPDATE serviceevent
                SET song_id = {0}
                WHERE service_id = {1} AND Seq_Num = {2}
                """.format(song_id, this_service_id, seqnum))

                con.commit()
    except KeyError:
        return False

    return True


def songs_html(s_id):

    html = """<html><head>
        {}
        <title>Add Congregational Songs</title>
        <h3>Available Congregational Events</h3>
        </head>
        <body>
        <form>""".format(css)

    cursor.execute("""
    SELECT DISTINCT
            song.Song_ID AS Song_IDM,
            song.Title AS Title,

            (SELECT
                    MAX(service.Svc_DateTime)
                FROM
                    ((song
                    JOIN serviceevent ON ((song.Song_ID = serviceevent.Song_ID)))
                    JOIN service ON ((serviceevent.Service_ID = service.Service_ID)))
                WHERE
                    ((Song_IDM = song.Song_ID)
                        AND (song.Song_ID = serviceevent.Song_ID)
                        AND (serviceevent.Service_ID = service.Service_ID))) AS LastDateUsed
        FROM
            ((song
            LEFT JOIN serviceevent ON ((song.Song_ID = serviceevent.Song_ID)))
            LEFT JOIN service ON ((serviceevent.Service_ID = service.Service_ID)))
        WHERE
            (song.Song_Type = 'H')
        ORDER BY service.Svc_DateTime , song.Title
    """)
    songs_with_id = cursor.fetchall()
    songs = []
    [songs.append(pair[1])
     for pair in songs_with_id if pair[1] not in songs]
    # only first 20 songs
    if len(songs) > 20:
        songs = songs[0:20]
    songs_string = '\n'.join(
        ['<option>{}</option>'.format(name)
            for name in songs])

    # all the congregational events in this service
    cursor.execute("""
    SELECT Event_ID, Seq_Num
    FROM serviceevent
    WHERE service_ID = {} AND EventType_ID = 5
    ORDER BY Seq_Num
    """.format(s_id))
    cong_events_id = cursor.fetchall()
    cong_events = []
    [cong_events.append(pair[1])
     for pair in cong_events_id if pair[1] not in cong_events]

    html += "<input name='service_ID' style='display:none' type='text' value='{}'>".format(s_id)

    i = 1
    for seqnum in cong_events:
        html += ("<p>Song {}: ".format(i))
        song_combobox = """<select name='{0}'>
        <option disabled selected value>Select a song...</option>
        {1}
        </select>""".format(seqnum, songs_string)
        html += (song_combobox)
        html += ("</p>")
        i += 1

    html += ("""
    <input type='submit' value='Submit'>
    </form>
    </body>
    """)

    return html


@bottle.route('/')
def generate_html():
    # Get service dates and times from the db
    cursor.execute("""
    SELECT service_ID, Svc_DateTime
    FROM service
    ORDER BY Svc_DateTime
    """)
    svc_datetimes_with_id = cursor.fetchall()
    svc_datetimes = [pair[1] for pair in svc_datetimes_with_id]
    svc_datetimes_string = '\n'.join(
        ['<option>{}</option>'.format(datetime.strftime(dt, datetime_format))
            for dt in svc_datetimes])
    template_service_datetime = """<select name='template-datetime' required>
        <option disabled selected value>Select a date/time...</option>
        {0}
        </select>""".format(svc_datetimes_string)

    cursor.execute("""
    SELECT person_ID, CONCAT(person.First_Name, ' ', person.Last_Name)
    FROM service JOIN person ON service.Songleader_ID = person.person_ID
    ORDER BY person.First_Name, person.Last_Name
    """)
    songleaders_with_id = cursor.fetchall()
    songleaders = []
    [songleaders.append(pair[1])
     for pair in songleaders_with_id if pair[1] not in songleaders]
    songleaders_string = '\n'.join(
        ['<option>{}</option>'.format(name)
            for name in songleaders])
    songleader = """<select name='songleader'>
        <option disabled selected value>Select a songleader...</option>
        {0}
        </select>""".format(songleaders_string)

    create_record_id = None
    create_record_errmsg = ""
    # Submit a record to the db
    if bottle.request.params:
        # after song choices have been chosen
        if 'template-datetime' in bottle.request.params.keys():  # bottle.request.params['template']:
            # Set current serviceID
            global template_service_id
            current_service = None
            dt_param = datetime.strptime(
                bottle.request.params['template-datetime'], datetime_format)
            for dt_i, dt in enumerate(svc_datetimes):
                if dt == dt_param:
                    svc_ids = [pair[0] for pair in svc_datetimes_with_id]
                    current_service = svc_ids[dt_i]
            if current_service:
                template_service_id = current_service

            # Set current songleaderID
            global template_songleader_id
            current_songleader = None
            try:
                sl_param = bottle.request.params['songleader']
                for sl_i, sl in enumerate(songleaders):
                    if sl == sl_param:
                        sl_ids = [pair[0] for pair in svc_datetimes_with_id]
                        current_songleader = sl_ids[sl_i]
                if current_songleader:
                    template_songleader_id = current_songleader
            except KeyError:
                template_songleader_id = None

            create_record_id = create_record(bottle.request.params)
            if create_record_id:
                return songs_html(create_record_id)
            else:
                create_record_errmsg = "<p style='color:red'>" \
                    "service already exists at that date/time.</p>"

        else:
            insertCongSongs(bottle.request.params)

    return """<html><head>
        <title>Worship service Creator</title>
        {2}
        <h3>Worship service Creator</h3>
        {3}
        </head>
        <body>
        <form>
          New service date/time:
          <input id='bonobo' type='datetime-local' name='Svc_DateTime' required>
          Template service date/time:
          {0}
          Title:
          <input type='text' placeholder='Title' name='Title'>
          Theme:
          <input type='text' placeholder='Theme' name='Theme'>
          Songleader:
          {1}

          <input type='submit' value='Add songs'>
        </form>
        <script>
            document.addEventListener('DOMContentLoaded', function() {{
                var now = new Date();

                var day = ("0" + now.getDate()).slice(-2);
                var month = ("0" + (now.getMonth() + 1)).slice(-2);
                var hours = ("0" + (now.getHours())).slice(-2);
                var minutes = ("0" + (now.getMinutes())).slice(-2);

                var today = now.getFullYear()+"-"+month+"-"+day+'T'+hours+':'+minutes;

                document.getElementById('bonobo').value = today;
            }})
        </script>
        </body>
        </html>""".format(
            template_service_datetime, songleader, create_record_errmsg, css)


# Launch the BottlePy dev server
application = bottle.default_app()
