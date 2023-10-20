#!/bin/bash

ROOM_ID=$1

# mx_request $endpoint
mx_request() {
    curl -sS -H "Authorization: Bearer $ACCESS_TOKEN" "$HOMESERVER$1"
}

# get_room_users $roomId
get_room_users() {
    mx_request "/_matrix/client/v3/rooms/$1/members"
}

# get_user_status $user_id
get_user_status() {
    user="$(printf '%s' "$1" | sed 's/\//%2F/g')"
    mx_request "/_matrix/client/v3/presence/$user/status"
}

# get_user_last_active $user_id
get_user_last_active() {
    get_user_status "$1" | jq '.last_active_ago'
}

get_inactive_users() {
    readarray -t user_ids <<< "$(get_room_users "$ROOM_ID" | jq -r '.chunk[].user_id')"
    for i in "${user_ids[@]}"; do
        last_active="$(get_user_last_active "$i")"
        days_inactive=$((last_active / 1000 / 60 / 60 / 24))
        printf "%s has been inactive for %u day(s)\n" "$i" "$days_inactive"
    done
}

get_inactive_users
