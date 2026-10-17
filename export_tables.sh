#!/sh

echo 'MySQL engine is online! Checking for imported tables...'
        
    until mysql -h db -u myuser -pmypassword bctransit -e 'SELECT 1 FROM bus_route, bus_stop, route_stops LIMIT 1;' >/dev/null 2>&1; do
        echo 'Data is still importing... waiting 3 seconds...'
        sleep 3
    done
        
    echo 'Database populated!'
    # Creates a folder names 'output_files' inside working directory if not already there
    mkdir -p /output/output_files
        
    FIRST_ARG=$1
    SECOND_ARG=$2

    if [ "$FIRST_ARG" = "bus_stop" ]; then
        echo 'Exporting information on Bus Stop Ratings and Accessibility...'
        #Querying from 3 tables and writing to one file
        mysql -h db -u myuser -pmypassword bctransit -B -e "
        SELECT
        s.stop_id,
        s.stop_name,
        r.type,
        r.average,
        t.name,
        t.value
        FROM bus_stop s
        JOIN ratings r ON s.stop_id = r.stop_id
        JOIN tf_accessibility t ON s.stop_id = t.stop_id;
        " | sed 's/\t/,/g' > /output/output_files/stop_rating_info.csv

        echo 'Exported Bus Stop Ratings and Accessibility Information to /output_files/.'

        echo 'Export Bus Stop information where wheelchair accessibility is true'

        mysql -h db -u myuser -pmypassword bctransit -B -e "
        SELECT
        s.stop_id,
        s.stop_name,
        t.name,
        t.value,
        t.updated_at
        FROM tf_accessibility t
        JOIN bus_stop s ON t.stop_id = s.stop_id
        WHERE name = 'wheelchair' AND value = 1;
        " | sed 's/\t/,/g' > /output/output_files/wheelchair_accessibility.csv

        echo 'Exported Wheelchair accessibility' 

        if [ -n "$SECOND_ARG" ]; then

            echo 'Export Bus Stop accessibility along route'

            mysql -h db -u myuser -pmypassword bctransit -B -e "
            SELECT 
            rs.position_index,
            r.route_id,
            r.route_name,
            s.stop_name,
            t.name,
            t.value
            FROM bus_route r
            JOIN route_stops rs ON r.route_id = rs.route_id
            JOIN bus_stop s ON rs.stop_id = s.stop_id
            JOIN tf_accessibility t ON rs.stop_id = t.stop_id
            WHERE r.route_id = '$SECOND_ARG'
            ORDER BY rs.position_index ASC;
            " | sed 's/\t/,/g' > /output/output_files/route_accessibility.csv

            echo 'Exported Route Accessibility'
        fi

    else
        echo 'Exporting bus_routes, bus_stops, route_stops, ratings, and accessibility table data...'
        # Querying and writing to three distinct files
        mysql -h db -u myuser -pmypassword bctransit -B -e 'SELECT * FROM bus_route;' | sed 's/\t/,/g' > /output/output_files/routes_output.csv
        mysql -h db -u myuser -pmypassword bctransit -B -e 'SELECT * FROM bus_stop;' | sed 's/\t/,/g' > /output/output_files/stops_output.csv
        mysql -h db -u myuser -pmypassword bctransit -B -e 'SELECT * FROM route_stops;' | sed 's/\t/,/g' > /output/output_files/route_stops_output.csv
        mysql -h db -u myuser -pmypassword bctransit -B -e 'SELECT * FROM ratings;' | sed 's/\t/,/g' > /output/output_files/ratings_output.csv
        mysql -h db -u myuser -pmypassword bctransit -B -e 'SELECT * FROM tf_accessibility;' | sed 's/\t/,/g' > /output/output_files/accessibility_output.csv

        echo 'Exported bus routes, bus stops and route stops to 5 files in /output_files/.'
    fi
    
