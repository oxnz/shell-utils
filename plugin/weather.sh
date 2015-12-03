################################################################################
# query weather info
# ref: http://openweathermap.org/current
# TODO: use ip2loc get location, then get weather by coord
################################################################################
function weather() {
    if [ $# -ne 1 ]; then
        echo "Usage: ${FUNCNAME[0]} [option] <city>" >&2
        return 1
    fi
    local -r city="$1"
    local -r baseurl='http://api.openweathermap.org/data/2.5/weather'
    local -r url="${baseurl}?q=${city:-Wuhan},${country:-cn}&units=${units:-metric}"
    ruby -e '
require "net/http"
require "json"

fmtime = lambda { |ts| Time.at(ts).strftime("%F %T %Z") }
res = Net::HTTP.get_response(URI('"'${url}'"'))
if res.is_a?(Net::HTTPSuccess)
    res = JSON.parse(res.body)
    printf <<EOF
Name: #{res["name"]}(#{res["sys"]["country"]}) coord(lon: #{res["coord"]["lon"]}, lat: #{res["coord"]["lat"]})
Sunrise: #{fmtime.call(res["sys"]["sunrise"])}, Sunset: #{fmtime.call(res["sys"]["sunset"])}
Weather:
EOF
res["weather"].each {|w|
    printf %Q/\tmain: #{w["main"]}, description: #{w["description"]}\n/
}
printf <<EOF
Temp: #{res["main"]["temp"]}(min: #{res["main"]["temp_min"]}, max: #{res["main"]["temp_max"]}), pressure: #{res["main"]["pressure"]}, humidity: #{res["main"]["humidity"]}
Wind: #{res["wind"]["speed"]} m/s, deg: #{res["wind"]["deg"]}
Clouds: #{res["clouds"]["all"]}
EOF
end
'
}
