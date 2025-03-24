#!/bin/bash

QUERY_DIR="./queries"

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <query_name>"
    exit 1
fi

QUERY_FILE="$QUERY_DIR/$1.sql"

if [[ -f "$QUERY_FILE" ]]; then
    dbask "$(cat "$QUERY_FILE")"
else
    echo "Query '$1' not found in $QUERY_DIR"
    exit 1
fi

