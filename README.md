# wsc: Worship Service Creator
A web application that allows the user to create a schedule for a church service. This was part of a database application development project for CpS 301 Into to Database Management. This is a tool for storing and creating document formats, for e.g. a church worship service.

## To install

### Requirements

*   Python version >= 3
*   A MySQL server already running the CpS 301 example WSOApp database. To setup this database:
    *   Start MySQL Workbench.
    *   Create a new schema named `wsoapp`.
    *   Populate `wsoapp` by importing the data from `wsoapp.sql` (included with this repository).
    *   Modify `login.conf` to work with your MySQL username, password, and database name.

### Instructions

*   Download or clone the repository.
*   Unzip the repository if needed.
*   `cd` into the folder you downloaded.
*   Activate the virtual environment by running this command:`source venv/bin/activate`
*   Note: on Windows the command will just be this:`venv/bin/activate.bat`
*   Run this command:`python wsc.py`
*   Connect to the webpage in your browser at address `localhost:8080`.
