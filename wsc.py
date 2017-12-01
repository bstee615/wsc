# To use this app:
#   pip install bottle

import bottle
from datetime import datetime
from mysql.connector import connect


def get_login_info():
    file = open('login.conf')
    info = []
    for line in file:
        info.append(line.split('=')[1].strip())

    return tuple(info)


username, password, database = get_login_info()
con = connect(user=username, password=password, database=database)
cursor = con.cursor()
template_service_id = None
template_songleader_id = None
datetime_format = '%m/%d/%y %I:%M %p'


def serviceExists(dt: str):
    cursor.execute("""
    SELECT count(Service_ID)
    FROM service
    WHERE Svc_DateTime = {0}
    """.format(datetime.strptime(dt, datetime_format).strftime("'%y-%m-%d %H:%M:%S'")))
    return cursor.fetchall()


"""
***insert a record into Service table***
Dictionary data contains info for the service record
-Keys are columns in service table
-Values are info to be inserted into respective columns
-Assumes that fields user left blank are NULL
"""


def create_record(data):
    print('Creating record in the database with these records...')
    for key in data:
        print('{} : {},'.format(key, data[key]))

    if not serviceExists(data['template-datetime']):
        print('Service date & time already exists.')
        return False
    else:
        fields = [
            'ServiceID',
            'Svc_DateTime',
            'Theme',
            'Title',
            'Notes',
            'Organist_Conf',
            'Songleader_Conf',
            'Pianist_Conf',
            'Organist_ID',
            'Songleader_ID',
            'Pianist_ID'
        ]
        for i in fields:
            if i in data:
                pass
            else:
                data[i] = 'NULL'
    # insert record into service table
        insert_record = ("""
                        INSERT INTO Service
                        (Service_ID, Svc_DateTime, Theme, Title, Notes, Organist_Conf, Songleader_Conf, Pianist_Conf, Organist_ID, Songleader_ID, Pianist_ID)
                        Values(
                        %(Service_ID)s, %(Svc_DateTime)s, %(Theme)s, %(Title)s, %(Notes)s, 
                        %(Organist_Conf)s, %(Songleader_Conf)s, %(Pianist_Conf)s, 
                        %(Organist_ID)s, %(Songleader_ID)s, %(Pianist_ID)s
                        )
                        """)
        cursor.execute(insert_record, data)
        con.commit()

    return True


@bottle.route('/')
def generate_html():
    # Get service dates and times from the db
    cursor.execute("""
    SELECT Service_ID, Svc_DateTime
    FROM Service
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
    SELECT Person_ID, CONCAT(Person.First_Name, ' ', Person.Last_Name)
    FROM Service JOIN Person ON Service.Songleader_ID = Person.Person_ID
    """)
    songleaders_with_id = cursor.fetchall()
    songleaders = [pair[1] for pair in songleaders_with_id]
    songleaders_string = '\n'.join(
        ['<option>{}</option>'.format(name)
            for name in songleaders])
    songleader = """<select name='songleader'>
        <option disabled selected value>Select a songleader...</option>
        {0}
        </select>""".format(songleaders_string)

    # Submit a record to the db
    if bottle.request.params:
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

        create_record(bottle.request.params)

    css = r"""
    <style display="none">
        * { display: block; margin: 4px; }
        style, title { display:none }
    </style>"""
    return """<html><head>
        <title>Worship Service Creator</title>
        {2}
        <h3>Worship Service Creator</h3>
        </head>
        <body>
        <form>
          New service date/time:
          <input type='datetime-local' name='Svc_DateTime' required>
          Template service date/time:
          {0}
          Title:
          <input type='text' placeholder='Title' name='Title'>
          Theme:
          <input type='text' placeholder='Theme' name='Theme'>
          Songleader:
          {1}
          <input type='submit' value='Submit'>
        </form>
        </body></html>""".format(
        template_service_datetime, songleader, css)


# Launch the BottlePy dev server
if __name__ == "__main__":
    bottle.run(host='localhost', debug=True)
