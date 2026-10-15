#!/sh

echo 'MySQL engine is online! Checking for imported tables...'
        
    until mysql -h db -u myuser -pmypassword bctransit -e 'SELECT 1 FROM bus_route, bus_stop, route_stops LIMIT 1;' >/dev/null 2>&1; do
        echo 'Data is still importing... waiting 3 seconds...'
        sleep 3
    done
        
    echo 'Database populated!'
    # Creates a folder names 'output_files' inside working directory
    mkdir -p /output/output_files
        
    FIRST_ARG=$1


    if [ "$FIRST_ARG" = "bus_stop" ]; then
        echo 'Exporting information on Bus Stop Ratings and Accessibility'
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
        JOIN tf_accessibility t ON s.stop_id = t.stop_id
        " | sed 's/\t/,/g' > /output/output_files/stop_rating_info.csv

        echo 'Exported Bus Stop Ratings and Information to /output_files/.'
    else
        echo 'Exporting individual table data to the output folder...'
        # Querying and writing to three distinct files
        mysql -h db -u myuser -pmypassword bctransit -B -e 'SELECT * FROM bus_route;' | sed 's/\t/,/g' > /output/output_files/routes_output.csv
        mysql -h db -u myuser -pmypassword bctransit -B -e 'SELECT * FROM bus_stop;' | sed 's/\t/,/g' > /output/output_files/stops_output.csv
        mysql -h db -u myuser -pmypassword bctransit -B -e 'SELECT * FROM route_stops;' | sed 's/\t/,/g' > /output/output_files/route_stops_output.csv
        
        echo 'Done! All 3 files have been saved to /output_files/.'
    fi
    echo 'End of File!'
