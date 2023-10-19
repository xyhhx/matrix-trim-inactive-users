#!/bin/bash

ROOM_ID=$1

mx_request () {
	echo $(curl -sS -H "Authorization: Bearer $ACCESS_TOKEN" "$HOMESERVER$1")
}

# get_room_users $roomId
get_room_users () {
    echo $(mx_request "/_matrix/client/v3/rooms/$1/members")

}

# get_user_status $user_id
get_user_status () {
	echo $(mx_request "/_matrix/client/v3/presence/$1/status")
}

user_ids=$(get_room_users "$ROOM_ID" | jq '.chunk[].user_id' )
printf $(get_user_status "$user_id_1" | jq '.last_active_ago')
