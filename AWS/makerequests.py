import http.client
import argparse
import pprint
import boto3
from time import sleep, ctime


SLEEP_TIME = 1


def connection(connection_number: int, conn_url: str, req_page: str, secure: bool):
    try:
        if secure == True:
            conn = http.client.HTTPSConnection(conn_url)
        else:
            conn = http.client.HTTPConnection(conn_url)

        conn.request("GET", req_page)
        resp = conn.getresponse()
        print(connection_number+1, resp.status, resp.reason)
    except ConnectionRefusedError as err:
        print(err)
        print("The connection was refused. Are you using the right type of the connection? (HTTP/HTTPS)")
        print("Adjust SECURE flag")


def main():
    parser = argparse.ArgumentParser(prog="Requests Maker 1.0 \n Adjust URL in LBDNS variable and adjust flag SECURE\n example: python3 ./makerequests.py -5",
                                     description="Program for making requests and get info from ALB activities\n"
                                                 "Example usage:\n"
                                                 "python .\makerequests.py -u google.com -n 3 -s - make 3 requests to google.com using https\n"
                                                 "to specify page to connect: python .\makerequests.py -u albamazondnsname.com -p /index.php -n 31 -s\n"
                                                 "to get data from your autoscaling activities use:\n"
                                                 "python .\makerequests.py -a - short view - only activity ID and cause\n"
                                                 "python .\makerequests.py -aa full view\n")

    parser.add_argument("-n", "--requested_number_of_smth",
                            action='store',
                            metavar="AMOUNT",
                            dest="req_number",
                            default=0,
                            type=int,
                            help="Specify the equired number of connections."
                                 "Example: -n 3 or -n 10"
                                 "The default value is 0 ")


    parser.add_argument("-a", "--get_activities",
                            action="count",
                            dest="get_activities",
                            help="Use it if you want to get activities"
                                 "example usage: -a for short view"
                                 "               -aa for full detailed view")
    parser.add_argument("-s", "--is_secure_http",
                            action="store_true",
                            dest="is_secure",
                            help="Use it for HTTPS"
                                 "example usage: -s"
                                 "omit -s if you need HTTP ")

    parser.add_argument("-u", "--url",
                            action='store',
                            metavar="URL",
                            dest="con_url",
                            type=str,
                            help="Put here url to create connections to ",
                            required=False)

    parser.add_argument("-p", "--page",
                            action='store',
                            metavar="page",
                            dest="page",
                            type=str,
                            default='',
                            help="Put here page to connect(if needed."
                                 "example: -p /index.php ",
                            required=False)



    args = parser.parse_args()

    if args.con_url:
        print(f"Using secure connection: {args.is_secure}")
        print(f"Connecting to: {args.con_url}")
        print(f"Desired number of requests: {args.req_number}")
        curtime = ctime()
        print(curtime)
        for con_numb in range(args.req_number):
            connection(con_numb, args.con_url, args.page, args.is_secure)

    if args.get_activities:
        try:
            asclient = boto3.client('autoscaling')
        except :
            print("Boto3 is not installed or no credentials and region provided in aws Configure")
        activities = asclient.describe_scaling_activities()

        if args.get_activities == 1:
            sleep(SLEEP_TIME)
            for activity in activities['Activities']:
                print(f"ActivityID:{activity['ActivityId']}\nCause:{activity['Cause']}\n\n")
        elif args.get_activities == 2:
            pp = pprint.PrettyPrinter(indent=4)
            pp.pprint(activities['Activities'])
        else:
            print("use -a or -aa")






if __name__ == "__main__":
  main()