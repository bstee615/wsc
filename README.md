# cps301-appdev2
Database application development project for CpS 301 Into to Database Management.

Project requirements:
<h1>Service Order Generator (50 points)</h1>
<p>
Create a GUI or web application that allows the user to create a new service based on an existing service (the “template”). You may use any technology or language that you wish.

Note: See these tips for setting up a Visual Studio project that uses Entity Framework. See also a sample C# GUI application in \bju\University\Courses\CPS301\Class\examples\GUIDBApp, along with a video walkthrough on youtube (https://youtu.be/Q4L7vF39gs8).

Prompt the user to enter the following info (the user must enter items with an *; the other items may be left blank):

*Date/time for new service – clearly indicate the format the user must follow when entering the date/time. Fill in the current date/time as the default value.

*Date/time for template service – Allow the user to select from a list of previous services. The list should be sorted by date/time.

Title

Theme

Songleader – Allow the user to select from a list of names of previous service songleaders.

When the user enters this information and clicks a “Create” button, validate it as follows:

There must be no existing service at the datetime specified for the new service.

If validation succeeds, insert a record into the Service table for the new service using the specified date/time, title, theme, and songleader. For values that the user left blank, use NULL. (20 points)

Insert records into the ServiceEvent table for the new service based on the events in the template service, except that the specific songs, personnel, and ensembles should be left blank. For example, if the user enters 10/3/2010 10am for the date/time for the template service, the program should insert ServiceEvent records for the new service that have the same sequence numbers and event types as those for the 10/3/2010 10am service.

Tip: The creation of all of the ServiceEvent records for the new service can be done with a single, carefully constructed INSERT statement. Review the notes to find the form of the INSERT that can generate records using a SELECT.

Bonus: In the final step of the application, allow the user to select songs to be assigned to the congregational song events in the new service. Create a view named SongUsageView that displays all of the colums in the Song table, plus one named LastUsedDate. The LastUsedDate column should contain the date of the most recent service that used that song. (Exclude choral songs, but be sure to include songs which have never been used). Using this view, display 20 of the least recently used songs, ordered by LastUsedDate, and then song title. Allow the user to select songs from this list, and assign them to the congregational song events.
</p>
