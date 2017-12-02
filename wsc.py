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


username, password, database = get_login_info()
con = connect(user=username, password=password, database=database)
cursor = con.cursor()
template_service_id = None
template_songleader_id = None
datetime_format = '%m/%d/%y %I:%M %p'


def serviceExists(dt: str):
    cursor.execute("""
    SELECT Service_ID
    FROM service
    WHERE Svc_DateTime = '{0}'
    """.format(dt))
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

    if serviceExists(data['Svc_DateTime']):
        print('Service date & time already exists.')
        return False
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
                        INSERT INTO Service
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
        fields = {
            'Service_ID': cursor.lastrowid,
            'Confirmed': 'N',
            'Old_Service_ID': template_service_id
        }
        insert_record = """
            INSERT INTO ServiceEvent(
                Service_ID, Seq_Num, EventType_ID, Confirmed)
            SELECT %(Service_ID)s, ServiceEvent.Seq_Num,
                ServiceEvent.EventType_ID, %(Confirmed)s
            FROM Service JOIN ServiceEvent
            ON Service.Service_ID = ServiceEvent.Service_ID
            WHERE Service.Service_ID = %(Old_Service_ID)s
        """
        cursor.execute(insert_record, fields)

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

    create_record_errmsg = ""
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

        create_record_success = create_record(bottle.request.params)
        if create_record_success:
            create_record_errmsg = "<p style='color:green'>" \
                "Successfully created record.</p>"
        else:
            create_record_errmsg = "<p style='color:red'>" \
                "Service already exists at that date/time.</p>"

    css = """
        <style display="none">
            * { display: block; margin: 4px; }
            style, title { display:none }
        </style>
    """

    return """<html><head>
        <title>Worship Service Creator</title>
        {3}
        <h3>Worship Service Creator</h3>
        {2}
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
        template_service_datetime, songleader, create_record_errmsg, css)


# Launch the BottlePy dev server
if __name__ == "__main__":
    bottle.run(host='localhost', debug=True)
