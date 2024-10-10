#!/bin/bash
# Define the PSQL variable to connect to the PostgreSQL database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument is provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Determine if the argument is a number (atomic number) or a string (symbol or name)
if [[ $1 =~ ^[0-9]+$ ]]; then
  # Construct the query for atomic number
  QUERY="SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.atomic_number = $1"
else
  # Construct the query for symbol or name
  QUERY="SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.symbol = '$1' OR e.name = '$1'"
fi

# Execute the query and store the result
ELEMENT=$($PSQL "$QUERY")

# Check if the element was found
if [[ -z $ELEMENT ]]; then
  echo "I could not find that element in the database."
else